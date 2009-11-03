require 'test/unit'
require 'rubygems'
require 'fakeweb'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'woot'

class Test::Unit::TestCase

  def self.attributes
    @attributes ||= Woot.selectors.map { |selector, results| results.keys }.flatten
  end
  
  def self.possible_blank_attributes
    @possible_blank_attributes ||= [:purchase_url]
  end
  
  def self.fixtures
    @fixtures ||= Dir[File.join(File.dirname(__FILE__), 'fixtures', '*.html')].inject({}) { |hash, file| hash.merge! File.basename(file).gsub(/\.html$/, '') => file }
  end
  
  def self.register_fakeweb_uris
    fixtures.each { |subdomain, file| FakeWeb.register_uri(:get, "http://#{subdomain}.#{Woot::DOMAIN}/", :body => File.read(file)) }
  end
  
  def self.woots
    @woots ||= (Woot::SUBDOMAINS + fixtures.keys).inject({}) { |hash, subdomain| hash.merge! subdomain => Woot.scrape(subdomain) }
  end
  
  register_fakeweb_uris
  
end

class MockTwitterStatus
  
  attr_reader :id, :text
  
  def initialize(id, text = '')
    @id = id
    @text = text
  end
  
  def user
    self
  end
  
end

WOOT_FIXTURE_VALUES = {
  'available' => {
    :subdomain       => 'available',
    :title           => 'Blockade Noise Isolating Earbuds - 2 Pack',
    :price           => '14.99',
    :currency        => 'USD',
    :currency_symbol => '$',
    :shipping        => "\n+ $5 shipping\n",
    :image           => 'http://sale.images.woot.com/Blockade_Noise_Isolating_EarbudsmqlStandard.jpg',
    :alternate_image => 'http://sale.images.woot.com/Blockade_Noise_Isolating_Earbudsqx4Detail.jpg',
    :url             => 'http://www.woot.com/sale/10457',
    :comments_url    => 'http://www.woot.com/Forums/ViewPost.aspx?PostID=3554500',
    :comments_count  => '71',
    :header          => 'I think the little hairy guy with the claws is popping my bike tires on purpose',
    :subheader       => 'Head down, earbuds in, try not to get hit by a laser',
    :writeup         => "\nMy mother-in-law thought we were crazy. &ldquo;You two are going to end up pulverized by a giant world-eating alien just like your Aunt Regina!&rdquo; We&rsquo;ve always wanted to live in Metro City, though, and when Jessica got that job offer at the Major Daily Newspaper, we were excited to move to where all the costumed action is.\nFor about the first three weeks, anyway.\nWhen the errant meteorite hit the Volvo, we shrugged it off and started using public transportation. Then, our dog Scamp was eaten by the Crimson Cowl&rsquo;s cyborg velociraptors. And around the fourth time some villain&rsquo;s robot henchman gets plowed through your wall and into your living room without so much as a &ldquo;Sorry, Citizens&rdquo; from whatever hero happens to be on duty that day, you start to get a little annoyed.\nI&rsquo;m not complaining, really. That&rsquo;s what cape insurance is for, after all. That&rsquo;s the price you pay for living in the superhero capital of the world, I guess. You either pack your things and move to Wyoming, or you learn to adapt. It just takes a little adjusting.\nSo on the nights when the sky burns red with crisis or some silver-plated intergalactic herald is preaching doom and gloom all over the city, my wife and I plug the Blockade Noise Isolating Earbuds into our MP3 players. The triple flange design provides optimal noise protection from all the laser blasts and explosions that flood the city soundscape, allowing us to concentrate on the music or audiobook we&rsquo;re listening to. When I need to take a trip down to the corner market and have to jump out of the way of an automobile being thrown by some hulking gamma-irradiated scientist, the comfortable fit of these earbuds means the music stays in my ears. The integrated volume control in the cord is great for when I want to drown out any superhero bellowing witty banter, too.\nIf anyone knows a good way of keeping some of these heroes from perching on the gargoyle outside our bedroom window at night, though, I&rsquo;d love to hear it. I know they&rsquo;re just doing their inner-monologue thing, but it gets kinda creepy.\n",
    :specs           => "\n\nWarranty: 90 Day Woot Limited Warranty\nFeatures:\n\nPatented triple-flange ear bud design provides optimal noise protection for an excellent fit that radically reduces noise\nIntegrated volume control places fingertip adjustment of any iPod or MP3 player easily within reach\n24 decibel Noise Reduction Rating brings an end to dangerously over-cranked tunes struggling to compete with loud external sounds\nUse in the yard while mowing and gardening, in the workshop, on the job, in the gym or traveling on a plane to safely isolate background noise\nUltra comfortable design from the same company who brought you the industry leading WorkTunes\niPod and MP3 compatible (any device with a 3.5mm plug)\nMeets ANSI/OSHA Standards\n\nAdditional Photos:\n\nBlockade Noise Isolating Earbuds\nVolume Control\nTriple-flange ear bud design\n\nIn the box:\n\n2 AO Safety 99014 Blockade Noise Isolating Earbuds\n6 Extra Pairs of Ear Tips\n2 Carrying Bags\n\n",
    :details         => "\nCondition:\nNew\nProduct:\n2 AO Safety 99014 Blockade Noise Isolating Earbuds\n",
    :purchase_url    => 'http://available.woot.com/WantOne.aspx?id=983db0c6-5c69-4737-926b-3697d4af542e'
  },
  'soldout' => {
    :subdomain       => 'soldout',
    :title           => 'iRobot Roomba 530 Robotic Vacuum with Virtual Wall',
    :price           => '129.99',
    :currency        => 'USD',
    :currency_symbol => '$',
    :shipping        => "\n+ $5 shipping\n",
    :image           => 'http://sale.images.woot.com/iRobot_Roomba_530_Robotic_Vacuum_with_Virtual_WalluquStandard.jpg',
    :alternate_image => 'http://sale.images.woot.com/iRobot_Roomba_530_Robotic_Vacuum_with_Virtual_WallyxlDetail.jpg',
    :url             => 'http://www.woot.com/sale/10244',
    :comments_url    => 'http://www.woot.com/Forums/ViewPost.aspx?PostID=3553042',
    :comments_count  => '209',
    :header          => 'Looking For Mr. Roombar',
    :subheader       => 'This is nice, isn&rsquo;t it? I have to say, I was surprised when you called me. Most people who date robots prefer the kind that, you know, look like people.',
    :writeup         => "\nI just keep thinking about all those times you came over to play cards with Len and Sherry. Of course I noticed you, but I never imagined you noticed me, way down on the floor in my self-charging home base. Well, there was this one time when I heard you ask Sherry about me. It made my heart leap. But then Sherry just started talking about how convenient I was, and how my counter-rotating Bristle Brush and Beater Brush work together like a broom and dustpan to lift hair, dust, and debris out of carpet. I just assumed you were interested in my cleaning abilities, not me personally. Glad I was wrong!\nWow, everything on the menu looks so good. I&rsquo;d heard about this place, but it&rsquo;s even nicer than I imagined. Well, except for the floors. It&rsquo;s like they think they can slap down a brown carpet and forget about ever vacuuming again. Well, they can&rsquo;t fool me and my Dirt Detect capability. Like that smear of, like, dried holladaise sauce or whatever it is, over by that booth. See, if it was up to me, I&rsquo;d really bear down with my Spot Clean mode, and I&rsquo;d have that crud lifted up before you could say &ldquo;new, improved filter&rdquo;. See, that&rsquo;s the difference between me and a regular old-\nListen to me. Talking shop in the middle of a lovely first date. Sorry. I just don&rsquo;t get out much.\nSo, uh, have you seen any interesting movies lately? I haven&rsquo;t. I&rsquo;ve actually never seen a movie in a theater. Every time I try, I see all that popcorn and all those crumbs all over the floor, and I just can&rsquo;t resist getting down there and sweeping it all up. Well, you can imagine the noise. I&rsquo;m loud, I know. What can I say? I grew up in a loud family. You get us together, it&rsquo;s VRRRR-VRRRR-VRRRR the whole time.\nWhat? Go back to your place? Sure. Yeah, that would be fun. I&rsquo;m not that hungry anyway. Um, yes, I did bring my Virtual Wall. Yeah, I emptied my Debris Bin right before you picked me up. Why do you ask?\nOh. Oh, I see. So it&rsquo;s like that. I guess I should&rsquo;ve known.\n",
    :specs           => "Authorized for SquareTrade Extended Warranty\n\n\n\n//<![CDATA[\n$(document).ready(function() {st_widget.create({itemCondition:'Refurbished',itemDescription:'iRobot Roomba 530 Robotic Vacuum with Virtual Wall',itemPrice:'129.99',bannerStyle:'wide',widgetType:'quote',merchantID:'subscrip_014793207843'}); });\n//\n\n\nWarranty: 90 Day iRobot\nFeatures:\n\nEfficiently vacuums dirt, debris, pet hair, dust, allergens and more from carpets and hard floors\nCounter rotating Bristle Brush and Beater Brush work together like a dustpan and broom\nSturdy Bristle Brush digs deep into carpet fibers to grab dirt, debris, pet hair and more\nPowerful vacuum sucks large and small debris into the large, bag-less bin\nFine filter traps dust, pollen and tiny particulate inside the bin\nCleans the whole floor, under and around furniture, into corners and along wall edges\nDetects dirtier areas and spends more time cleaning them\nSpot Clean provides quick clean-up of spills and concentrated messes\nAutomatically senses and avoids stairs and other drop-offs\nSimple operation&mdash;just press the Clean button and Roomba does the rest\nAutomatically returns to its self-charging Home Base&reg; to dock and recharge between cleanings\nFaster counter-rotating brushes with improved design pick up more hair and debris and are easier to remove and clean\nImproved filter captures more dust and allergens while a larger bin holds more debris\nImproved anti-tangle technology keeps Roomba from getting stuck on cords, carpet fringe and tassels\nImproved sidebrush makes Roomba even more efficient at cleaning edges and corners\n\nAdditional Photo:\n\nUnderbelly\nIn Home Base with Virtual Wall\nVirtual Wall\n\nIn the box:\n\n1 iRobot Roomba 530\n1 Virtual Wall&nbsp;\n1 Self-charging Home Base\n1 Power Supply (3 hour charge time)\n1 Rechargeable Battery\n1 Filter\n\n&nbsp;\n",
    :details         => "\nCondition:\nRefurbished\nProduct:\n1 iRobot Roomba 530 Robotic Vacuum with Virtual Wall and Self-Charging Home Base\n",
    :purchase_url    => nil
  }
}
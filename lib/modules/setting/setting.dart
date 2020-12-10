class Setting {
  static final Setting _instance = Setting._internal();

  // DEFAULT SETTING
  static int requestItemPerPage = 10;
  static String blogUrl = "https://blackbusinessescaribbean.com/blog/all";
  static String aboutusContent = "Economic power is the key to advancement of a people. Circulating Black dollars within our community and doing business with each other is critical to the generation of financial and economic strength within the Black community.\nBlack Businesses Caribbean is committed to economic progress, prosperity and wealth creation within the Black community. We leverage our collective power and business acumen to create the infrastructure and to advance policies that can and will create economic empowerment in our communities. We reflect the VOICE of Black Businesses in the Caribbean:";
  static String vision = "A vision guides our thoughts which guide our actions which guides our outcomes. Each business entity should have a vision and that vision contributes to economic empowerment in the Black community.\n“When you know your why, your what becomes more clear and impactful.” ~ Michael Jr., Black comedian";
  static String OPPORTUNITY1 = "Through inspired action we make our dreams a reality.\nEach business entity should see, seize and realize opportunities: NOW is the time to create shifts in power and to change levels.\n“Take advantage of every opportunity; where there is none, make it for yourself.”\n~ Marcus Garvey, Black political activist, publisher, journalist, entrepreneur, and orator";
  static String INNOVATION = "Innovation is the monetization of an idea. Each business entity should exist for reasons beyond just making a profit and should create sustainable revenue models that build up themselves and their communities\n“You don’t make progress by standing on the sidelines, whimpering and complaining.  You make progress by implementing ideas.” ~ Shirley Chisholm, first Black woman elected to the United States Congress";
  static String CALLING = "We don’t follow money, we follow our dream and the money will follow us. Each business entity should exist for reasons beyond just making a profit and should seek to arrive at an optimal fit between its higher purpose and its resources and capabilities\n”If you wake up deciding what you want to give versus what you're going to get, you become a more successful person. In other words, if you want to make money, you have to help someone else make money.” ~ Russell Simmons, Black entrepreneur, record executive, writer, and film producer";
  static String EXCELLENCE = "What we do excellently will bring excellent results back to us. Each business entity should operate at a level of efficiency and effectiveness that will encourage the community to make Black-owned businesses their first choice for any and all their business and professional needs.\nYou’re not obligated to win. You’re obligated to keep trying to do the best you can every day.\n~ Marian Wright Edelman, Black activist for children's rights.";
  factory Setting() {
    return _instance;
  }

  Setting._internal() {
     // Init properties here
  }

}
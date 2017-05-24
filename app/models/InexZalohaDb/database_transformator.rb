class DatabaseTransformator < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(
    adapter: "mysql2",
    encoding: "utf8",
    pool: 5,
    username: "inex",
    password: "inexinex",
    socket: "/var/run/mysqld/mysqld.sock",
    database: 'inexzaloha3'
  )

  # Transform data in this table into my database
  def self.transform
    IActivity.transform
    IAlliance.transform # + IOrganization(2)
    IUser.transform
    ICamp.transform # + i_cheif, i_chief2camp, i_chief_job, Musi mat predchodcu IUser.transform
    IWorkcamp.transform # + i_cheif, i_chief2camp, i_chief_job, Musi mat predchodcu IUser.transform a IAlliance.transform
    IMemberApplication.transform
    IVefReg.transform
    ICourseApp.transform
  end

end
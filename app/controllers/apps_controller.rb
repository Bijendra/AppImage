class AppsController < ApplicationController


def index

end

def home
  if(!session[:uid].blank?)
    @user = Userdatum.where(uid: session[:uid].to_s).first
  else 
    redirect_to root_path
  end
end

def saveAppEntry
app_entry = Appentry.new
	app_entry.uid = session[:uid]
	app_entry.story_url = params[:url]
	app_entry.description = params[:desc]
	app_entry.status = "pending"
	app_entry.img_src = params[:img_selected]
	app_entry.like_count = 0
	app_entry.comment_count = 0
	app_entry.share_count = 0
	app_entry.points = 0
	if app_entry.save
render :text => "success"
 else
render :text => "failure"
end

end

def gallery
@app_entries = Appentry.all
end

def likeRemoved
app_entry = Appentry.where(:story_url => params[:response])
	app_entry.each do |entry|
		entry.like_count = entry.like_count - 1
		entry.points = entry.points - 1
		entry.save
	end
render :text => "Success"
end

def updateShareCount
app_entry = Appentry.where(:id => params[:id]).first
app_entry.share_count = app_entry.sahre_count + 1
app_entry.points = app_entry.points + 5
app_entry.save
end

def commentRemoved
app_entry = Appentry.where(:story_url => params[:response].href)
	app_entry.each do |entry|
		entry.comment_count = entry.comment_count - 1
		entry.points = entry.points - 3
		entry.save
	end
render :text => "Success"
end

def saveUserInfo
omniauth = request.env['omniauth.auth']
if !omniauth.blank?
		if !omniauth.uid.blank?
                        session[:uid] = omniauth.uid
			prev_record = Userdatum.where(:uid => omniauth.uid).first
			if prev_record.blank?
				user_data = Userdatum.new
				user_data.uid = omniauth.uid
				user_data.name = omniauth.info.name
				if omniauth.info.email.present?
					user_data.email = omniauth.info.email
				end
				user_data.save
			else		
				prev_record.name = omniauth.info.name
				if omniauth.info.email.present?
				 prev_record.email = omniauth.info.email
				end
				prev_record.save
			end
			if(!session[:uid].blank?)
			  @user = Userdatum.where(uid: session[:uid].to_s).first
			end
			render action: "home"
		else
			render action: "index"
		end
	end

end

def fetchUrlMetaData
url = params[:link]
    if( !url.blank?)
    page = MetaInspector.new(url,:html_content_only => true)
    # title = page.title
    # description = page.description
    images = page.images
    img1 = images[0].blank? ? "": images[0]
    img2 = images[1].blank? ? "": images[1]
    img3 = images[2].blank? ? "": images[2]
    logger.info images.blank?
      if (!page.title.blank?)    
      render :json => {
              title: page.title,
              description: page.description,
              img1: img1,
              img2: img2,
              img3: img3
          } 
      else
        render :json => {
          error: page.errors[0]
          }
      end
    else
      render :json => {
        error: "Provide a valid link"        }
      
    end
end

def likeAdded
app_entry = Appentry.where(:story_url => params[:response])
	app_entry.each do |entry|
		entry.like_count = entry.like_count + 1
		entry.points = entry.points + 1
		entry.save
	end
render :text => "Success"
end

def commentAdded
app_entry = Appentry.where(:story_url => params[:response].href)
	app_entry.each do |entry|
		entry.comment_count = entry.comment_count + 1
		entry.points = entry.points + 3
		entry.save
	end
render :text => "Success"
end

end

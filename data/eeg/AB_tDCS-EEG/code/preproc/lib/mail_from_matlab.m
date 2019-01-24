function mail_from_matlab(message, subject, recipient, sender, password)
%sender = string with gmail-adress to send FROM, e.g. 'abc@gmail.com'
%password = string with password for this gmail account
%recipient = string with email adress to send TO (does not have to be gmail of course)
%subject = string with subject line for the e-mail
%message = string with text for body of the e-mail

if ~exist('subject', 'var') || isempty(subject)
    subject = 'Yo, it''s Matlab';
end
if ~exist('recipient', 'var') || isempty(recipient)
    recipient = 'leonreteig@gmail.com';
end
if ~exist('sender', 'var') || isempty(sender)
    sender = 'automailLCR@gmail.com';
end
if ~exist('password', 'var') || isempty(password)
    password = 'r6BM@8u&c%';
end

setpref('Internet','E_mail', sender);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username', sender);
setpref('Internet','SMTP_Password', password);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail(recipient, subject, message);

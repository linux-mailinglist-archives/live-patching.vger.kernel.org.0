Return-Path: <live-patching+bounces-400-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BAAD937F14
	for <lists+live-patching@lfdr.de>; Sat, 20 Jul 2024 07:57:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B0281F219FB
	for <lists+live-patching@lfdr.de>; Sat, 20 Jul 2024 05:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C83101E4;
	Sat, 20 Jul 2024 05:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AU7atu5B"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DDCF9E9;
	Sat, 20 Jul 2024 05:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721455034; cv=none; b=YbFg3hc+BUS4o70JkdQ6ifBT1jvzzZ4QaETTKG5lor0b+So1IJ7vQzG9yGYt69xu1j7ErCKhjZ0DHRmrDrEFMxq6mpmsC+q55LmKcXuyNlift5Nm3SKGlnXM4G/42SYJb0WE+tAbqw53g9iKrN/JGbYP3v7oCZrt0lWn0h/6tvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721455034; c=relaxed/simple;
	bh=LnDWqsAbe5y5qscXWlNkz8tmNBpYP0ADznL6Jm0l3sY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mIPdUCmUX0obf4U6cp3NyiLOGK0vZgVDYXe0ae6wtByqeTCttuAE7XDuyBINx9BM2AZYYcXb1BhUY1sIffiUpZxx76YTtjciawnkeiubrxU0UqvPhIgiAz6qYo6EPjEa9ByxdHYDpTazhpezVyFdqA27LH4zGJRtoPKu1cfASWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AU7atu5B; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1fc6ee64512so15141315ad.0;
        Fri, 19 Jul 2024 22:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721455032; x=1722059832; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LnDWqsAbe5y5qscXWlNkz8tmNBpYP0ADznL6Jm0l3sY=;
        b=AU7atu5BusEgCBvrPgSryhxvqVPybSIXw71MOmI3PG2nEFJeCo+M0LYvnEVYucYZ8P
         q1PpuBwPVx0F+Ioc5ggi18KQEsgEyB3uNbymb17YqHLReeJ0JUiuVkCBBNtyc2LfrDda
         Jn4fXhGt1QyHlCEbDu/Dz1y7arKXc4tbjT7xd9iSEOfGv4sJKXfPEyDg2z3X/UIpMH2A
         sMjB88aVnDK7YZvC4/E9fS3oqdOMyHTKQ3Zm8tfmCztrsio38WkOQpVxN8b9wYTLrwRh
         nzFkOXBrOQ9herddzVxDHscBj/6dzGmXKZYzWQKBogIEth6IxJ8M6ix55K/ULU5hGXvv
         sVpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721455032; x=1722059832;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LnDWqsAbe5y5qscXWlNkz8tmNBpYP0ADznL6Jm0l3sY=;
        b=SW0Mg/VL1liK0AtHFJQNMj6rGIubWQpgQ2KvrUeGJ+OO0bPASwUgKCHWW1C+t8RbZw
         CWVKy3kQwB/3OLCN+97WGrGCSS0ieiPFrQ/RYHahku+PRD7cZmX/ttfJhsnWgtqgt1c2
         IggEzXgd+6r48jS3YyiG7s6oCyL920FS+JsX5Ps1HbSg7hLnPmgU4NkHqzzmiFzFpkg4
         s7tsNbdI0LPzVmqkwGYpMMwPO6IlMedF2URW09O4iaQkwCvVRY0wtm8EJp4M/8guHCdr
         8qlqHPBYCdS62OFb7Ixo96/VdXfuSqOTGT7qvCweGcUzrTdJbtWFw4z9wCIlMxIv1iKT
         qAWA==
X-Forwarded-Encrypted: i=1; AJvYcCWF39OvmY/wPHQ7ooh4eenoJI02S5/nsPSeK3nUQijUHcAgiDnOCmA/bcmXsqEJUtvHc4IOWZLbD8/q5n5hVIGSYazbVq+M1kpXMf5AjANykSGYEoaMN+qxWXww8ngFGoa4kxsRnqCujBTdJw==
X-Gm-Message-State: AOJu0Yz54ALTfxkN+GPPMAv0b8HuRPVCpomi0SbOHr+wd3Ytekua9mtl
	hVQQIWZ/UgpRQ1rAL4PuvsOoRr9eoXtyo2Y1hpyBAOq6K+iJCg3W
X-Google-Smtp-Source: AGHT+IF5SRgeLqmPjs6sQElt3xmASewjjV6gnDAH+C8N4x1txklmylBbLFnrbtg86gsW2ph0OCNpPw==
X-Received: by 2002:a17:902:ce83:b0:1fb:8c35:602f with SMTP id d9443c01a7336-1fd74573a4amr14660395ad.6.1721455031944;
        Fri, 19 Jul 2024 22:57:11 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f436cc2sm14249785ad.202.2024.07.19.22.57.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2024 22:57:11 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: Add using attribute to klp_func for using func
 show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <alpine.LSU.2.21.2407191402500.24282@pobox.suse.cz>
Date: Sat, 20 Jul 2024 13:56:56 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <07DD1CA1-7E53-4E67-92DC-ECEC11424804@gmail.com>
References: <20240718152807.92422-1-zhangyongde.zyd@alibaba-inc.com>
 <alpine.LSU.2.21.2407191402500.24282@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


> is this always correct though? See the logic in klp_ftrace_handler(). =
If=20
> there is a transition running, it is a little bit more complicated.
>=20
> Miroslav

Hi! Miroslav.

In reality, we often encounter such situation that serval patch in one =
system, some patch make changes to one same function A. This make us =
confused that we don't know which version of function A is now using.=20

In my view, this "using" state show the function version that is now =
enabling. Even if there is a transition running, the end state of one =
task will finally use patchN's version.

If we see the attribute "using" is 1, it mean that livepatch will use =
this function to work but seem to be not all task running this version =
because the "transition" flag of this patch is "1". We can be told from =
"transition" that if all threads have completed synchronization.

So, the main function of this attribute is to enable user space find out =
which version of the patched function is running now (or will use after =
transition completed)in the system.

Please see if I have explain my opinion clearly.

Thanks!
Wardenjohn.



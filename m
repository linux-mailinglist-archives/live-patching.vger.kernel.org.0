Return-Path: <live-patching+bounces-1098-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E8B3A23E87
	for <lists+live-patching@lfdr.de>; Fri, 31 Jan 2025 14:39:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C7841883FB7
	for <lists+live-patching@lfdr.de>; Fri, 31 Jan 2025 13:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E1F11C54A6;
	Fri, 31 Jan 2025 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RL2kNlco"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107321C5490
	for <live-patching@vger.kernel.org>; Fri, 31 Jan 2025 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738330784; cv=none; b=q2l23gvswCsphmA7sstDlnCIW94Xn+2xPd2BrCxMgBr4dq3rMp+wwrAjvDGsP+3t8dYBJbZvEitx0irgWPyGDw34CL5qJs8zLJs8tnbnppSFmfpEgly3hsF/Dmlf6t4gBHZx3Yu0CZDXMklCwGOGZAD8ZumFW4bePJ3Xdb4uFB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738330784; c=relaxed/simple;
	bh=5mPvwptlf4DtLEnRZROAjz3PwSrVT/z8HCRCWrE+0zU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uxpr8N+NnQuMGAmi98bwtN3JydS/Mog3am4JCsaXjR7/IJyUZ7/QG0miN30BTjoXFhJywTk5YzDsLJRU/0AmNAnOJ6Of0iPPCo3JWhS/oN7UWdK+KDwh1O+VUwPReBOKGktP6jdtCbxViq31EmqdVJ2UES6eW58zxZFqjxRxPis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RL2kNlco; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaf57c2e0beso415463366b.3
        for <live-patching@vger.kernel.org>; Fri, 31 Jan 2025 05:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738330780; x=1738935580; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ra7Ibv/sS08m+ODIR8OnFPWUOI+sb96Q6qvU5SAJ7wE=;
        b=RL2kNlcoioYI964x6o59P5UNXNUgagoYOH5l50XvpCnRIHPWq/hM+r1ogobeIvhmLX
         RUrrad2Z9JIYkLPu6tJxAn3biJZI/3soKaonSRIVx1pl5/wWWVLt2cJYi8p17a8UxtCP
         L5lBUQraEq5jBcJMokimBTvDMT7/h/BpJ5b4TFn+yxzRz1oKuT+GCwNC1ARzZ8v6SMdo
         YLYPW/3vHJgC3KbfGOBSvccYy+DQXBTTKirlKAY7Nh6TGoZXGHKxYjSc4uOKFbyQOkOS
         +a2oYEM4PDN6qg4eLl5vj00E2vOOaQEcDghwmnT9jeYV7KuyD2M9QSdUebFxhtKVrBQ/
         J0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738330780; x=1738935580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ra7Ibv/sS08m+ODIR8OnFPWUOI+sb96Q6qvU5SAJ7wE=;
        b=N7w6ZNfP4yVaqSndM2roFr1gjNJt6AO8n+sZ8h2LGZOb7mTEB5Us2MwuvvAv3139lU
         2AXa9ZrevKhobtVAX/H99ZhHvS5JweR2Ca5vOgfUabZRSsBxAWrvYcc9h5UJVTwg/PP7
         7cjOfHQLIwmTz39QkeDUZNDECHc4g7JI8lw39Hu8tsj3CwYCTa4tctFqOhgaIvFjhc4F
         2f73cPpMEkmz26NcvlyaNl5GaFjd4mWnLd6c3eSYJ6CzZtHIU0a1lFQNkdVakKDf0dmG
         Mpjesjae8/ipSsE7yc/0PuIcFqPDXj78kbanzloLtXvFVtmJWmJKddvyQQ6mdHQbAhs8
         GnlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuDBGTlyukhib+OJzplCK7ip5UMcCw/qe6HYEob0TX3X+OPpB+pZv4zFvrWmAvd4+N33iomGYvXacbipXq@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3v62X+CL232OkZqiq8ybxidbENlGLMCHhmV5Qs/2T/kULos6B
	zAyQe9CBKmJ0TAevujv7dLPDJSfGfefOK/ag6W4CyLzUMos6mIAnOc01QPLSPNg=
X-Gm-Gg: ASbGncssAEZtVkIiySUmQQC3pmIuERmdI8gBq8N6amF2wDAevsj4O4WZNgnWmVxHZLh
	oC5q3JRkIYCDeTJE8B803KU/1o9YwldIHez4Fy5UkrN1xX9mw+wynH8hkknyfMhVq6rWVSDZzZd
	f3Eb4ecES9w8WdJ1GwmuXlxjwIC1DMrBKqoN4xPI3EplEBtiu5ylLYSgOvXyix+HDJ6/N+X2h+C
	2eVAfQsKZTUh87CyFhAdbDOXC41KJDrwGfTRCQ16hc1bf9Q2rXwKXccoe2iCrPROvSR+4bjua9T
	+UhDcaFJHBDySsdlKQ==
X-Google-Smtp-Source: AGHT+IHP/WIMYzilZvXccoBY8gfalcJV1AHX2OR4/RxvXSDgVvCKARVkyhXA/3NlA9ir2bbVErCIew==
X-Received: by 2002:a17:906:4696:b0:ab6:d0b9:8fd1 with SMTP id a640c23a62f3a-ab6d0b99468mr1105120566b.34.1738330780235;
        Fri, 31 Jan 2025 05:39:40 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e49ffd79sm298789066b.93.2025.01.31.05.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 05:39:39 -0800 (PST)
Date: Fri, 31 Jan 2025 14:39:38 +0100
From: Petr Mladek <pmladek@suse.com>
To: zhang warden <zhangwarden@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH] livepatch: Avoid hard lockup caused by
 klp_try_switch_task()
Message-ID: <Z5zSmlRIv5qhuVja@pathway.suse.cz>
References: <20250122085146.41553-1-laoar.shao@gmail.com>
 <Z5DpqC7sm5qCJFtj@pathway.suse.cz>
 <A250B752-FFBF-4A53-B981-FE6D9A9F5C14@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A250B752-FFBF-4A53-B981-FE6D9A9F5C14@gmail.com>

On Fri 2025-01-31 21:22:13, zhang warden wrote:
> 
> 
> > On Jan 22, 2025, at 20:50, Petr Mladek <pmladek@suse.com> wrote:
> > 
> > With this patch, any operation which takes the tasklist_lock might
> > break klp_try_complete_transition(). I am afraid that this might
> > block the transition for a long time on huge systems with some
> > specific loads.
> > 
> > And the problem is caused by a printk() added just for debugging.
> > I wonder if you even use a slow serial port.
> > 
> > You might try to use printk_deferred() instead. Also you might need
> > to disable interrupts around the read_lock()/read_unlock() to
> > make sure that the console handling will be deferred after
> > the tasklist_lock gets released.
> > 
> > Anyway, I am against this patch.
> > 
> > Best Regards,
> > Petr
> 
> Hi, Petr.
> 
> I am unfamiliar with the function `rwlock_is_contended`, but it seems this function will not block and just only check the status of the rw_lock.
> 
> If I understand it right, the problem would raise from the `break` which will stop the process of `for_each_process_thread`, right?

You got it right. I am afraid that it might create a livelock
situation for the livepatch transition. I mean that the check
might almost always break on systems with thousands of processes
and frequently created/exited processes. It always has
to start from the beginning.

Best Regards,
Petr


Return-Path: <live-patching+bounces-140-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17DB882B18C
	for <lists+live-patching@lfdr.de>; Thu, 11 Jan 2024 16:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 961C31C2131A
	for <lists+live-patching@lfdr.de>; Thu, 11 Jan 2024 15:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403E94B5DD;
	Thu, 11 Jan 2024 15:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C7DPFKF2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB0C4D13A
	for <live-patching@vger.kernel.org>; Thu, 11 Jan 2024 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-50eabfac2b7so6196357e87.0
        for <live-patching@vger.kernel.org>; Thu, 11 Jan 2024 07:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704986272; x=1705591072; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=89hILc8fV7OBcQ3dgWJZyYhw//2b4isBBhmMXFJEhAw=;
        b=C7DPFKF26TKMW6PIxoivqKUA5SrT38l7Ad2wSTuGTrdxOr4pvcn/XtJJnArSgAThBD
         +AJVaKIL3zWu3Alt1XtESNfGve9xBaNfbNeaQHzD/AZcQDKPGRQO5X0RjluT8WvmO0tY
         v60aOrPFce65cCrPyzmRBMfLDRSgAZ9AilBNYWnQGPLwxaH5Aqm+5LW9fYzpM/j/PWGH
         ApuHTQxZav7V9/TiGCDLYaicK1ctgwfRMLScHU817hX3cOxx/THJyBvCsfF98ReIHiKs
         O9lAUrz340sf20lrciVKgEE0YG/eTmAaGrMGZnMFpSDWCyllREaUHYu2bI15M6sKCR1A
         86Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704986272; x=1705591072;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=89hILc8fV7OBcQ3dgWJZyYhw//2b4isBBhmMXFJEhAw=;
        b=Zk+ON8etI+IJEE83SdOYUwwtNlNRW2h1OPQQmoiVZQZhdaykQ+yxH/mboyXg2XTYsb
         9Nc8XZnkeOOfLcRg2rNEDxhOTvEvFvM1oNu7EuxjhvXrZfhpUw6byrtNKFK5K+7PmQ5S
         ejnggFQBd+DqpZfu3q1Wo/AeN3eU1SUo+BKjOaVfADNWFM1nzdfbsQs7iaIfdT8/xKtk
         tdm0VSoQdZm7sKS3jQiDvCZl+HOTEswgdqOUHA+pfJcDv0peBUWF9ouCx5bxmSHpmKLQ
         3lqUj/zcYY8FuK67ad1Kt+2soN/+7M91GefcI8m/Ts09KzeJjMPhlmJbBd/SjNfKu6Dx
         LtFw==
X-Gm-Message-State: AOJu0Yz9gHjTBLI+MiSHhc/iJbZj4Jl2oyLPtVm1uq/qkUqWIbb6A5jW
	SLU+bPUIzpZ+vKgj4Mmw/ZR7SC4ebftJLQ==
X-Google-Smtp-Source: AGHT+IGQxjTvuqUbZLYG67DMQyCKnaTyvAuZG8a1BLSP0ZFzDwIZ8/MUR8Cx7JtmDfDxDr9JNiEvUQ==
X-Received: by 2002:a05:6512:e85:b0:50e:abd1:bfc3 with SMTP id bi5-20020a0565120e8500b0050eabd1bfc3mr778644lfb.88.1704986272241;
        Thu, 11 Jan 2024 07:17:52 -0800 (PST)
Received: from alley ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id m23-20020a50ef17000000b0055751515a84sm709308eds.51.2024.01.11.07.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 07:17:52 -0800 (PST)
Date: Thu, 11 Jan 2024 16:17:50 +0100
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Attreyee M <tintinm2017@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation/livepatch: Update terminology in livepatch
Message-ID: <ZaAGnlmCMbl0dhij@alley>
References: <20231223205813.32083-1-tintinm2017@gmail.com>
 <87o7eg607d.fsf@meer.lwn.net>
 <ZYpb6Woh45ZnEvCP@archie.me>
 <CAJjsb4reD_TVWRFonp90xXD4Ye2OOfOd894PzmfMKaP3qFkbYg@mail.gmail.com>
 <87jzohoy02.fsf@meer.lwn.net>
 <49cfdce3094fcc37ecf01bb358509c64ee8feed9.camel@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49cfdce3094fcc37ecf01bb358509c64ee8feed9.camel@suse.com>

On Wed 2024-01-10 15:51:40, Marcos Paulo de Souza wrote:
> On Wed, 2024-01-10 at 11:15 -0700, Jonathan Corbet wrote:
> > Attreyee M <tintinm2017@gmail.com> writes:
> > 
> > > Hello maintainers, 
> > > 
> > > I wanted to ask if this patch of mine is accepted as of now. 
> > 
> > You never responded to the question that is still quoted in your
> > (unfortunately top-posted) email:
> > 
> > > So this is a classic example of saying what you have done, but not
> > > why.
> > > What makes this a change that we want?
> > 
> > So no, not accepted.  Even with a proper changelog, though, I'm not
> > sure
> > I see the value in that particular change.
> 
> >From time to time I see people complaining about the lack of new people
> coming to kernel development,

IMHO, it is much worse on the maintainers' side. There is a lack
of maintainers. And I believe that most of them have hard times
to manage the load. They should provide hints. But we could
not expect that they would do the work.

> and that Documentation would be a good
> start for some of them to learn how to send patches by email (which by
> itself is difficult...).

Attreyee, please read Documentation/process/submitting-patches.rst
before you send another version.

Also please run scripts/checkpatch.pl before you send the patches.

> As Documentation patches aren't backported, why not accept this patch?
> 
> Jon, I understand your reasoning, but I agree with Attreyee here. The
> term "acquire" fits better when in conjunction with "released" than
> "get".
> 
> Can you show an example of a good commit message to Attreyee so he can
> adjust and resend? I'm sure the next time he'll consider remember the
> suggestion given and the next patch will have a better commit message.

I suggest that Attreyee makes another attempt himself.

John explained what was the problem. Attreyee could get inspiration from
the git history. Anyway, the commit message simply should explain why
"acquire" is better than "get".

Best Regards,
Petr


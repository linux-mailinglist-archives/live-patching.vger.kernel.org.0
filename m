Return-Path: <live-patching+bounces-622-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C21D96F976
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 18:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8BBF1C21B92
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 16:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368881D365C;
	Fri,  6 Sep 2024 16:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QEwGQuVB"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1E6322A
	for <live-patching@vger.kernel.org>; Fri,  6 Sep 2024 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725640802; cv=none; b=hfxPv0AMF0gkra+lCTUI/zTpJUwgMgJNyJX3Hravbb6p8JUPif/R3K+D5Owo+CZF46x0OkLZv832hA+p9pkzYpw/K2tFbGC90q/spnDdNfN2OWZunLvLLlSW7kf0JuZsCcPAVfuJPxjKFtSIQwZgorVLqwZyRGZP1777WywCg9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725640802; c=relaxed/simple;
	bh=P9Eryl5SCGSwf+/z7iLEZUpwtqsdlYrJ1wkIzKBU3SU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=afW9fVAcwLRmqw1XOpe7EzGrD7BIHmpvwq/f9QsxhkLkcMcvUoPkg1zKaw69ds2B3btxMG8lGAalut6f1/3HV/vk354uyIdGcx9HMgVsKXVhYsZV0vYomm2Qb45mGk0sp67RwNpsTS5Kj7iIPZEMCUkffDPiSkfvsNdgOuxfwHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QEwGQuVB; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a8a789c4fc5so305967666b.0
        for <live-patching@vger.kernel.org>; Fri, 06 Sep 2024 09:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725640799; x=1726245599; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QF/ebzmzQk3Rvt7bUbW4XRiKYFS0zEetz6yd91MTpio=;
        b=QEwGQuVBA3s49ZdxMgyOOQf2gPWUaWoq7zrgLSi/E3ViEFHP3Nc21Zc6zTmRA3/YNV
         D3iTImKbxMwdYJtKQVjnXc5N2xZwJ7UMu+0P30gTR6P6TjYAniOaCwI/j5vsWVF8FXQo
         N+Nx9VdEhvb+J+0FZWI4lXVNFxsjwUavnPGYigUzdwm5ZVIpJ8auYqsW/5gKeBCvGBFA
         GLjzsg73G0KLjsb+9tqI2wr0u5c1SB6HUu2YOVUaW+j420hD4SM/FArSQPJT8yGQOxhi
         N93KpMP2gLB1wbpcFFO9tKp9Qh1+kq7DjLsv/dEgQWGTMOOQXHKmRP3HK+oMSLdGe7SS
         NQKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725640799; x=1726245599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QF/ebzmzQk3Rvt7bUbW4XRiKYFS0zEetz6yd91MTpio=;
        b=EX8hIWm7mmdD6hPiAwXUHaEvpJ6gFrlPuycws+6CqdC1nm31G0n77TqkbSbnR6gWgE
         5GKPzrBWr697jcSnGa6uTIE8U4110UDqXP4PVE27iOaf4vDPWSIxJ4EmDwFu+0JmOg1y
         rg3PEpHaDk82jXu1QZ21zxhP4H8dPcIdBd6IAglR1At9KaVSouyTXKlAb1nG7I3d67OT
         6QaKbdNkynPINCcUx/TnxEgTN7LFjNaEZrXz93saj+NR6GD6XPqc7KuWIMyG09LqgDxi
         QVD1utmLNaRT4vgVqdJKSu1AM/Luo2W+i6KSI+iIhOZueksjeIf+NXee8Q/EfUhVGRPw
         HYIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRsIXnxzepTjum5mBLYr9vCsg/3hJ7sk3bSWuBRP1XjhJwxG/3XVYnNNvGPLRzQ5yi/+aR0B/qUekxjCDu@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/hT50dU9ALm8xA8bwsuG4vFNwvx3skJkF0RJfvejrBSAplm03
	97zIfCJ09lAysx/7IAktWMRIEZBSXxosgIlL0d0vLEut5Fu9XDyQ2UiQtajGM0E=
X-Google-Smtp-Source: AGHT+IHBVZlr6HZWdZFnGdPIe/stiZVSdziTDEHho/C+HkkwlqCK9AL+pQ7P/fc4xWY+NVIYws13oQ==
X-Received: by 2002:a17:906:ee8e:b0:a75:7a8:d70c with SMTP id a640c23a62f3a-a8a85f330a6mr394147566b.4.1725640798595;
        Fri, 06 Sep 2024 09:39:58 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a61fbaf2dsm294998066b.30.2024.09.06.09.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 09:39:58 -0700 (PDT)
Date: Fri, 6 Sep 2024 18:39:56 +0200
From: Petr Mladek <pmladek@suse.com>
To: zhang warden <zhangwarden@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Jiri Kosina <jikos@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
Message-ID: <ZtswXFD3xud0i6AO@pathway.suse.cz>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
 <20240905163449.ly6gbpizooqwwvt6@treble>
 <285979BA-2A85-495F-8888-47EAFC061BE9@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <285979BA-2A85-495F-8888-47EAFC061BE9@gmail.com>

On Fri 2024-09-06 17:39:46, zhang warden wrote:
> Hi, John & Miroslav
> 
> >> 
> >> Would it be possible to just use klp_transition_patch and implement the 
> >> logic just in using_show()?
> > 
> > Yes, containing the logic to the sysfs file sounds a lot better.
> 
> Maybe I can try to use the state of klp_transition_patch to update the function's state instead of changing code in klp_complete_transition?
> 
> > 
> >> I have not thought through it completely but 
> >> klp_transition_patch is also an indicator that there is a transition going 
> >> on. It is set to NULL only after all func->transition are false. So if you 
> >> check that, you can assign -1 in using_show() immediately and then just 
> >> look at the top of func_stack.
> > 
> > sysfs already has per-patch 'transition' and 'enabled' files so I don't
> > like duplicating that information.
> > 
> > The only thing missing is the patch stack order.  How about a simple
> > per-patch file which indicates that?
> > 
> >  /sys/kernel/livepatch/<patchA>/order => 1
> >  /sys/kernel/livepatch/<patchB>/order => 2
> > 
> > The implementation should be trivial with the use of
> > klp_for_each_patch() to count the patches.
> > 
> I think this is the second solution. It seems that adding an
> interface to patch level is an acceptable way.

It seems to be the only acceptable idea at the moment.

> And if patch order
> is provided in /sys/kernel/livepatch/<patchA>/order, we should
> make a user space tool to calculate the function that
> is activate in the system. From my point to the original
> problem, it is more look like a workaround.

It is always a compromise between the complexity and the benefit.
Upstream will accept only changes which are worth it.

Here, the main problem is that you do not have coordinated developement
and installation of livepatches. This is dangerous and you should
not do it! Upstream will never support such a wild approach.

You could get upstream some features which would make your life
easier. But the features must be worth the effort.

Best Regards,
Petr


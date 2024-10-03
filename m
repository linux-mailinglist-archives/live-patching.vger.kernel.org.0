Return-Path: <live-patching+bounces-709-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1E598EE9B
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2024 13:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15E4D1F2206B
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2024 11:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1E415624C;
	Thu,  3 Oct 2024 11:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dvWdm/8b"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEB6155330
	for <live-patching@vger.kernel.org>; Thu,  3 Oct 2024 11:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727956620; cv=none; b=RFTvM41/uUUea+TCpT1SG9L6+cU+EJiLhCdMbYyCctKnh5oODpOmjwcuLRI/VoWgNTTbu8nIiKz5buo9B3JFrRMq1hiYpdmHGSXTv3TGKq28VuKvUB/K7fwmIKxm3P5G//pydsKSAJ6BMfASMaaq4zbGOIQTMBJkCUzvGra/cag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727956620; c=relaxed/simple;
	bh=/gi9qlrt440LOzNu5Rf+lTXE2gSw7tDfJPv+GvPP9HI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pkUIaNIX/eZr8lN419IJh0/wQ38Kx1OGd2I+kT4DfXxP7StCyT7v3RcQzpViqXFirxjvgC8ufqeydjnhWUTKl/pu5CKZdM37dF9+s9l9d7kmBCfj7UO1xjTweXlWPfezg2Pwl0i/NQf+FILiLoMWwfRjEwN98tC7wdxoJCCJmcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dvWdm/8b; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fac6b3c220so13059001fa.2
        for <live-patching@vger.kernel.org>; Thu, 03 Oct 2024 04:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727956617; x=1728561417; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HEIm+V0HVEumHxJE/X2zGEG++sznEkEVsJ4nCX5J6Rc=;
        b=dvWdm/8bgBaOOoxhkFNcVE71CQxutVaz2tHim8E4GJlMOa+fInwNPHsLn0jyvn4iSt
         CqN2SMn1Pb/aAgrhjsZRVWLGCuxTmeT2/wnfGGJZFEVykMXoxTcJc0nmUAW5D+YrG7ez
         bvm6v2GfcqBMQIEgwlEmoXw2hTBriW6xpvZD4lh/6PewMxXeDBxYKY4n9Ldtd/IK+iVz
         dBN4lbFCShllniujwleJt6bY1MHQZKFVN5ywdT7xMd2lxbErt7e5FADgi2VJpBWWUxIB
         8w77OOnV8Uh0uZQMP2Cog+d+HlahB/3eezy3rjEj9nGmBabxD1IKBMxdwWBAIXVtzmTD
         tgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727956617; x=1728561417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEIm+V0HVEumHxJE/X2zGEG++sznEkEVsJ4nCX5J6Rc=;
        b=gIFutkdJbAcxpEoaD5EE5zghyl5GVPbrWbkFRfZt0pGoPPVxOVLPmMuhugmrY9oGIG
         xhI0maHdVkhrZpuawqyFV4kktnDcayvhukOhGohikgPLTiEkjLKtQ1pLBbO9dHBvTrzC
         X6Legs9+EQA8U1i8oXzU7G3B1VkHAUNgbB3HjyFrrE8VrdUT0vqwgoZPc84MQIIGTwMr
         qUmN11DYf8o//zUHDJBjlEPfg0944EhHpv0uu88lGwZ9R97ZE0lfBIT3aB7Y3Vk8vle3
         F0dz6q3paV7o7OgxT6CDtulG5ZiOc4lCfpGJrkQSqgLSB3PimdzV0cRP8gg11Ob9ReNc
         zKWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVW5XooSbjFp7aolElJjApb6PDb5oFFC+RsXImrBFDT3Lo8+Rl7fikTScJ0ugHJK08etZUrfR7HZ7ND5JA6@vger.kernel.org
X-Gm-Message-State: AOJu0YzBVCIUl4UlJya2RUYAIGVbNcNeLRaO5P1bxunoA7Vl1oz3NsFr
	3WG3xS3SW18trPAF18/t4RpWejd82Okct2kbTxXoSn+Ah/p56m0dbU+ampTGqOg=
X-Google-Smtp-Source: AGHT+IGSqIGJXAgMoHGlqejYWmgnGglmufWBUzwpKHV0/qcOctHHorcg91PB3iu//oeluOcFV6pZWQ==
X-Received: by 2002:a2e:9907:0:b0:2fa:bd56:98c5 with SMTP id 38308e7fff4ca-2fae10a628cmr49809591fa.33.1727956616971;
        Thu, 03 Oct 2024 04:56:56 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99102a5d60sm76891866b.62.2024.10.03.04.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 04:56:56 -0700 (PDT)
Date: Thu, 3 Oct 2024 13:56:55 +0200
From: Petr Mladek <pmladek@suse.com>
To: zhang warden <zhangwarden@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/1] livepatch: Add "stack_order" sysfs attribute
Message-ID: <Zv6Gh4c66aS-X1Fg@pathway.suse.cz>
References: <20240929144335.40637-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2410021343570.19326@pobox.suse.cz>
 <CADDyLDU4Hsp-FCjocEyfEmY6-JOKeH+YjsBfUr+xbO=opOEhgw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDyLDU4Hsp-FCjocEyfEmY6-JOKeH+YjsBfUr+xbO=opOEhgw@mail.gmail.com>

On Thu 2024-10-03 16:06:59, zhang warden wrote:
> Hi,Miroslav.
> 
> >  could you also include the selftests as discussed before, please?
> 
> Should I submit the selftests in one patch?

I would put it into a separate patch from the patch adding the
"stack_order" attribute.

You might split the selftests into more patches if many selftests
are added.

Best Regards,
Petr


Return-Path: <live-patching+bounces-1005-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1859EA13EA7
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 17:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89F98160D71
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 16:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD40E22BAD5;
	Thu, 16 Jan 2025 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R1g5Qipq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EF422BAB7
	for <live-patching@vger.kernel.org>; Thu, 16 Jan 2025 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737043283; cv=none; b=QEy1Q1LENCSJ+pn+pO/cI9xUunpGc4GAX52z/chJK2+DyuMdDfaCl1ndSr9xFg4Ak8UTdYg9AJZw4UCeC0Vt627mKyTr/gajjRxHKZN5dn3rjvaO5WeEWLOM8fJsFP0hn608x3vSEivedEm3j4e97u7A/GTE8iKOBGq/GROWSnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737043283; c=relaxed/simple;
	bh=tigM6bjyDvl2pOI4h3OJAxGLP27Zzozsgw5WEqHdF60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGhLPvCp+ykUvVQQpi468Qn/Pv8cVFcC822to+p4MR92lTQBXi+LF4nSRzqMKkXRJYmVTK0+p9mmEnFAP//4wBx3TLw1OJyiUDYzDIPs1p8YnDQ+98CQ7kKwULFSfDHOrXv8T7j9M0MSAl3sBVyR18SEnXPKoLfZRwJkPTXeUxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R1g5Qipq; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-436a39e4891so7312475e9.1
        for <live-patching@vger.kernel.org>; Thu, 16 Jan 2025 08:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737043280; x=1737648080; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JCm3+RjhVuSQCejMVhKRl/6oWniP2n2Ur3OehXT3ivA=;
        b=R1g5QipqaLZZt8fTtbEpEJZomPrNOxtxOCfzhCjwRvciNHZHhTefhHYNjxFWIqVjmU
         gjkYUbTpME02zZqQRB3TYLrdmYP4oS4rxeSsk5UsPqdYaasQr4iGz0x6clRqxnhg8hZ3
         xGsXfRMcShsQ0alMCXnVDch/WXo17m5mnx5j/oj+SE8z3kNJoc38Fe80lfGcX9FxEmDH
         2damYHjaudkLeV65pRd5GKjmOEnILnB0tBPUEpxUh5o3eLp9VYN/wC3Y794Yl3IBpvLX
         VnowuMT78sndni8rjCY8H7HBknisx8QLORx30K5Y5HubArkheU3MvAWwq1/rt4PhJ7yE
         Lh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737043280; x=1737648080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCm3+RjhVuSQCejMVhKRl/6oWniP2n2Ur3OehXT3ivA=;
        b=D10CzjAhvscYsZGdPsFw8gp7iZBDTnt/WCPZLrRuunUh+bwK1uE67xWFEuNDmwomE/
         8P67VNAn7EykvsA77MvxFd6ls6XU0MidQsiQMu+tuGiR0uuIlQzwOzSnfvic1m6a+HTp
         idVa9pwNxAUagj4KwXYyjMNgZYwfJ3/lscpYZUxl+VIAGQpbj/Seuz/scrd87NzyToB0
         B3d4jeZ0Nbg15p4OaqhQkmkVzeOfu4mGVxZ96vjY7M219biBhgKSyMQzdFlgLFMZgPV8
         EZCGus7MgYRgQpbjH3bPdEkYubjVLsdFlDJOsirFFSuRHixEIT77uIEzA6YaB9Zepnb+
         Ol6Q==
X-Forwarded-Encrypted: i=1; AJvYcCX0k9T63E/4GsrBDncX06jlnAk4LeW2LSHLqhHgWhGuScze8Znbg37FF5PAoBu6xZ3P3dvlRIVjFU5NzxAl@vger.kernel.org
X-Gm-Message-State: AOJu0YylSnD2TRA+CAJR9B+dhs67J6CMh1OJEKS1IdHSpPVwXZZhIL7o
	/ON+eQzfAdNJuNwVPsEO9XeBk0mbqDNSsBoxZwkrXF6OrY0Jhrq2Zm6Lw0F8D9A=
X-Gm-Gg: ASbGncs46Aty8C+kqus/VAFh2xATpwpVGj0v20uIzcGZBBnGCMZPy/GQQYTfqRn4DId
	1NQNK3H+xPYnnRufygMMh3QcTqiO7J71OtgyxVhFiivRejXQsDg9AxZiYaT7tgzpONS1rcQyJ+w
	8yTRixXQ32VjVwXOBIOpVClSW5oqp/22Y9UyGcDYF58+AJKxTvK8vMFHK8eKuZgTP8QarNSYPuu
	qYQdHB0+PNlWNXEhKi5a3/gRjBG4yu+NER+VZtsQWXPeukh6wtZKe2X0w==
X-Google-Smtp-Source: AGHT+IHyRz1gyv15Lqi1nuYBzi/mTSC1DAiPMnP5AAlwXnopn/osJQo1L+qc7o/1JvWFWfdLziK1Kg==
X-Received: by 2002:a05:600c:3aca:b0:434:f335:855 with SMTP id 5b1f17b1804b1-436e26eb428mr259739245e9.28.1737043279871;
        Thu, 16 Jan 2025 08:01:19 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4389046b0f5sm3188465e9.39.2025.01.16.08.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 08:01:19 -0800 (PST)
Date: Thu, 16 Jan 2025 17:01:17 +0100
From: Petr Mladek <pmladek@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, jikos@kernel.org,
	mbenes@suse.cz, shuah@kernel.org, mpe@ellerman.id.au,
	npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen@kernel.org,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] selftests: livepatch: handle PRINTK_CALLER in
 check_result()
Message-ID: <Z4ktTdwl8aqqwZpf@pathway.suse.cz>
References: <20250114143144.164250-1-maddy@linux.ibm.com>
 <Z4jRisgTXOR5-gmv@pathway.suse.cz>
 <af77083e-2100-ea2e-ae14-dc5761456fef@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af77083e-2100-ea2e-ae14-dc5761456fef@redhat.com>

On Thu 2025-01-16 08:10:44, Joe Lawrence wrote:
> On 1/16/25 04:29, Petr Mladek wrote:
> > On Tue 2025-01-14 20:01:44, Madhavan Srinivasan wrote:
> >> Some arch configs (like ppc64) enable CONFIG_PRINTK_CALLER, which
> >> adds the caller id as part of the dmesg. Due to this, even though
> >> the expected vs observed are same, end testcase results are failed.
> > 
> > CONFIG_PRINTK_CALLER is not the only culprit. We (SUSE) have it enabled
> > as well and the selftests pass without this patch.
> > 
> > The difference might be in dmesg. It shows the caller only when
> > the messages are read via the syslog syscall (-S) option. It should
> > not show the caller when the messages are read via /dev/kmsg
> > which should be the default.
> > 
> > I wonder if you define an alias to dmesg which adds the "-S" option
> > or if /dev/kmsg is not usable from some reason.
> > 
> 
> Hi Petr,
> 
> To see the thread markers on a RHEL-9.6 machine, I built and installed
> the latest dmesg from:
> 
>   https://github.com/util-linux/util-linux
> 
> and ran Madhavan's tests.  I don't think there was any alias involved:
> 
>   $ alias | grep dmesg
>   (nothing)
> 
>   $ ~/util-linux/dmesg | tail -n1
>   [ 4361.322790] [  T98877] % rmmod test_klp_livepatch

Good to know. I havn't seen this yet.

> >From util-linux's 467a5b3192f1 ("dmesg: add caller_id support"):
> 
>  The dmesg -S using the old syslog interface supports printing the
>  PRINTK_CALLER field but currently standard dmesg does not support
>  printing the field if present. There are utilities that use dmesg and
>  so it would be optimal if dmesg supported PRINTK_CALLER as well.
> 
> does that imply that printing the thread IDs is now a (util-linux's)
> dmesg default?

It looks like. The caller ID information is available also via
/dev/kmsg but the older dmesg version did not show it. I guess that
they just added support to parse and show it. It actually makes
sense to show the same output independently on whether the messages
are read via syslog or /dev/kmsg.

So, we need this patch, definitely ;-)

Best Regards,
Petr


Return-Path: <live-patching+bounces-2248-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IGvlG1hMvWlr8gIAu9opvQ
	(envelope-from <live-patching+bounces-2248-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 14:32:08 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CB89F2DB05A
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 14:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3659F3070DC4
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 13:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB52D2773D3;
	Fri, 20 Mar 2026 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EiyOY4q5"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F9D274FE8
	for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 13:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774013520; cv=none; b=LhDU6xlcAc+vqBDL84XuH1hE9uy9r/b1QGP37q3vPDeGNh8/a02Kfw+GeRYLR3ZEjyorq7azQ7J0QQ7lInj4OyuzTPl5aJheCDD6qO89+ZylC+vehmriF0EgGAOOFSXy4OYMydxZdPAQ2Ch6C/DmCtFexRq5/Up/yBSHLhNV3Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774013520; c=relaxed/simple;
	bh=wY5zD2n0xMPvK2mJYnUtl70hsw8J6F9rA9251e67RkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eyTfl/BF3gBHF3bDXZ4cxa31b0LpfTsqNp4mAf3x3uCQFbkl3XxshC6zwlnJNa4tW3Zxm7xr2V+h7DNtEq8tvlKiEtapj5rIn/yT9cTGCVLPL2qd0jirxIf8K5IytqfR7FJcTDSvGwbVmcObPZP6Z2nyFeMxeTr6Zh9tmPBgUVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EiyOY4q5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48700b1ba53so5292765e9.1
        for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 06:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774013518; x=1774618318; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=amc/zHZZsI9E8OgKdEyfRT1GbcDfhXpxuLDiJuXetJ4=;
        b=EiyOY4q5CG6535iQ32YmD5B5CIben1RtM2vL+agjqwqZG6CEde62TSmAZOF11+A8oI
         P/ijbnC9Pp+8PewO/rPOMIrk1GiuaDVqk3gHzFCgZFZqABivPf7g23YFR5Td2WHK2rhI
         rrNADZcn+aAsIwUvy/Kd/bNIyEoPPfTY4mhbrqz4XdGXqEx9OYM8dFktUOtj3U45Ejs2
         Nb7t1zZvlKUQGpcf6GafAdbsAxauiFG+/K070q7Lg9V2cL0osM65AG+1Y9v/gIMUv38c
         4pSW6OE8jwtfd7wARCP9rFniDCnNooxTCp3lEhx5w5xvglBBcHanZruGSKx7iBTKG1ek
         dqOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774013518; x=1774618318;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amc/zHZZsI9E8OgKdEyfRT1GbcDfhXpxuLDiJuXetJ4=;
        b=OV20lxQIyyDNjlSmL5daNFqE8sfxdvfdPHewHTs5p5SxIaN0XJuBzfL1PJnKmcKDrr
         bG1r8o8Qn3qr3fqtl+Vumg8aEUzu5lCXmq6yYxXxLRaUFUbvIyUbQKHQHIi/b+vsf0Fa
         kXZQjXgkUb54qw9mvqHY98bemRDmyZ2LsPO+U3woZCp5pC5y0XFEUzuZZ9TIj6zXJOqO
         QDKcI4YMO+ZvMZDsvqJCjtffUb8UT0ywNw8NQCCXMQ3fRq7keJlv7sxEWdk7B5M//1T8
         QqPlBu9rPWABhUkAybg5+w8YQtPnAlGs8Kbfd3V/7fEpjXjng9wjSGrOlYPFFwh/Nzvo
         M6lQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNavDRiPp4Ur88/sSH2oig/HfcPfwJ92nbOosFVrXxTHrQJxBbz3JHYhsSqRwylYZVGX7uS8Sikx8O+3P+@vger.kernel.org
X-Gm-Message-State: AOJu0YyfprTdHy1Wahbemowl+yye1BL6OxGU5LMUyXtfS8WcIvVhf7qi
	IkFTAppefj0e44UnAS0zGhIr2lhgne6pxpZr3wHBhUGJOTrfQvgD5eQj6njo7XKQjIU=
X-Gm-Gg: ATEYQzyMH1cmVeZCWQ6ewnFZRWfVP/bS7VSURxcOQUn7gJnIBtgPyWN7RPO2MbRrXzs
	Q6HGmEkxwYGGmBeh2ndIzA4bC+8TG1Ud9Wl/jqdLeGb5EN0dX1IFnWHKxgLNyKJIiYU7qp8SSK2
	P3sMInpgfp9/kM98Ir2qxidRjaPeYuOwh6FZZ8qKFWWDk9EVtb26OnF676UEwiyfElkycZiYq/P
	NDV85gCI28lgBCvqUmNZeDwgFUgy0E2Lg8CS8T6xx9Wyh4itae2n0p2GTy/qe1KbaVR+11OgNNL
	ag5ecXCmm3o11qbdIBiIkmnTAFTlhmS8W7ik0/cBBdk6AwG77Y+hM8O3FaLpMRPrDrnqMiozyVk
	3w5On8dLpQPTKp/KwFmJa9qnDWILX+gylYjgzqdn+NDQr0eGVzcAWs7Drm0gG12IJluc7s0bfSk
	m5bKbitwaF0ZB9p5uEGeRCWj0CwA==
X-Received: by 2002:a05:600c:8b06:b0:485:41c4:e2e4 with SMTP id 5b1f17b1804b1-486fee1ae91mr48403695e9.23.1774013517736;
        Fri, 20 Mar 2026 06:31:57 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48700377b71sm18314375e9.0.2026.03.20.06.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 06:31:57 -0700 (PDT)
Date: Fri, 20 Mar 2026 14:31:55 +0100
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] kselftests: livepatch: Adapt tests to be executed on
 4.12 kernels
Message-ID: <ab1MS1OmUVZsmTGq@pathway.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2248-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.989];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,sashiko.dev:url,pathway.suse.cz:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CB89F2DB05A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri 2026-03-13 17:58:31, Marcos Paulo de Souza wrote:
> These patches don't really change how the patches are run, just skip
> some tests on kernels that don't support a feature (like kprobe and
> livepatched living together) or when a livepatch sysfs attribute is
> missing.
> 
> The last patch slightly adjusts check_result function to skip dmesg
> messages on SLE kernels when a livepatch is removed.
> 
> These patches are based on printk/for-next branch.
> 
> Please review! Thanks!

JFYI, I am suprised how good was the review made by the Sashiko AI, see
https://sashiko.dev/#/patchset/20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253%40suse.com

It pointed out many problems mentioned in the human review.
IMHO, it was also able to explain them very well.

Well, it missed some higher level views.

Best Regards,
Petr


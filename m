Return-Path: <live-patching+bounces-883-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41DEC9E93F0
	for <lists+live-patching@lfdr.de>; Mon,  9 Dec 2024 13:29:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E011F285FA2
	for <lists+live-patching@lfdr.de>; Mon,  9 Dec 2024 12:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4EF2236E5;
	Mon,  9 Dec 2024 12:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G1CKTvxd"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA062236EF
	for <live-patching@vger.kernel.org>; Mon,  9 Dec 2024 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733747345; cv=none; b=hG6xyyxF1HkkN0o+ZIgn9o/nQ/R6wOqUEsSJnfjBRm/HVCmmlU6+sJPsn6XlIsM8HrOP3VEgrncdL639rKS3yfaoIi+TOilOf6/usltqOsEaqRXWXcGEGWC7KlGzH223jTU9Jnf741mJDCvA+0Bq7C0ecbZPDnzwbMcrWVpzyYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733747345; c=relaxed/simple;
	bh=Qkk0kDiJ7iVTZVBmpiuPSmH5N0pAA4DlMttgSaOYgro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m+ybmIC5bKKYGyr815au1KvFdWAmEbEpBnSEWPTLvrFJX4bEGIfvcX1PEGwxYmb2MqZR1L3JoeuVUYHTGqmd99jk7/VTBCVMUQfVzcU+hKiM1u+JQB8fEwd8YSiUwWdnw5AITqloJnXekIgTNp8G8jtPcfvcv7t9umNPajc7ukU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G1CKTvxd; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-385f06d0c8eso1994984f8f.0
        for <live-patching@vger.kernel.org>; Mon, 09 Dec 2024 04:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733747342; x=1734352142; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JacI4mB04a8LmhCK/TbvYbOJL2q6pHnlqOBJlZwmZq8=;
        b=G1CKTvxd76YhVBp31/pAarpeZyFenu5UgkFORJFN6c+T3ftiX08xa444Pfpn2KzXSz
         OjkbmYLWnpINEfJ2CXpgOP7XmZrDbGifVe0zZxQQwJHQSoIVpg2y95+oDWkqm+vI/co1
         EnA0dKrbBeC6F2UObCQFLVLAUK4S9Wzz20+b4WlIq254Ig2feRpZmRKLzEE+2+SOXJb2
         gK3JQaG0FYscZIKywp1Y/BFp1e8eUoGfx1U4oK9E2l6nLBnjSMw8IvYtYg87voUVXZpE
         FYba1oezOlNMuvMx/iu/7gw+fbKVicZ0Lc0WLth5E0FzoATQryotz0uFVQn3eEJVfsWG
         AQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733747342; x=1734352142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JacI4mB04a8LmhCK/TbvYbOJL2q6pHnlqOBJlZwmZq8=;
        b=s6VoDPd3ik1I/vNq4XCATbIdEtOWPoNoJHRxkQuKvjCy4MrjtcKXyKP9Ixo0IHTWTn
         SuU3u86am/bcdhPY0PmXgwd4HsBR7Xr8sf3QX/IWMNi9j83wcaJRfaDkGwN3pvpPb6/i
         xmNr7LRaIosx4vuBKSyBgywRbXFi7GSHK6JWGAA/49/TKn17uXIiyyavMvqcdPjZHpC3
         9fxNJUUzMVIjsNupffHgy5EpnPBDgQmez2OZ5xtDsl+5B9grVLEKq5I8kHVn2+q7VES5
         Guv7bPcAp93E6/k6RMkzUYg2x5/ptRkHw9LK+fepOBGAf7FkP7U3ybWEayrgQmtoAhoM
         BDDg==
X-Forwarded-Encrypted: i=1; AJvYcCWE3xwuehJuBjDDt6toEFHXI5gsf2Shj79ESoEA/CFf2JGK8clPN/kzqEvMdf6lFdLYX4i+xK4Q1y17rLub@vger.kernel.org
X-Gm-Message-State: AOJu0YwCZtZWyc2ZiFw5BMm4GTq7NAnFDO/6619p3Ss8rVeoKkydK9h2
	SonrwTb2v46qP5Qyj+L3zL9sqt5NDONEyx6au3V9/21UYzXOulUj9jl2w4FK5LU=
X-Gm-Gg: ASbGncvfHkWmLjhdzp36ElaTPCJea9kfnFEBOSngbtnsKqgDOpGimZ53tsj0KQ35jBT
	MuUyV7BbeRNNcF14QubAhYNICKsYBMeQd08AVchXDdNkQQkq+vQoW9JAJYlsZv6z2ch85X+d6Lk
	V5cA5y5GGfz76oYL2ft5PxZjyfTZETaHs1G1pkgjxq9PQhZU+0ssHu8WdWUOe4v6CFbL0kQmg9L
	1jTqpQQ5+vAVJhEjmJ1PiIxIHHu7r2QLAYXhxPXsz50S0ENbAI=
X-Google-Smtp-Source: AGHT+IE+6SrVhA7lxXXWZ2TRa5Vtd+x05Nx18JSjzrlkUyDRkzVakZMiRRWDAFfWkUvG1F7oja5peA==
X-Received: by 2002:a05:6000:2aa:b0:385:ee40:2d88 with SMTP id ffacd0b85a97d-386453c6383mr137490f8f.3.1733747341754;
        Mon, 09 Dec 2024 04:29:01 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fd15698cd7sm7350830a12.7.2024.12.09.04.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 04:29:01 -0800 (PST)
Date: Mon, 9 Dec 2024 13:28:53 +0100
From: Petr Mladek <pmladek@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 1/1] livepatch: Add stack_order sysfs attribute
Message-ID: <Z1bihaY1sJkioopk@pathway.suse.cz>
References: <20241008014856.3729-1-zhangwarden@gmail.com>
 <20241008014856.3729-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008014856.3729-2-zhangwarden@gmail.com>

On Tue 2024-10-08 09:48:56, Wardenjohn wrote:
> Add "stack_order" sysfs attribute which holds the order in which a live
> patch module was loaded into the system. A user can then determine an
> active live patched version of a function.
> 
> cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1
> 
> means that livepatch_1 is the first live patch applied
> 
> cat /sys/kernel/livepatch/livepatch_module/stack_order -> N
> 
> means that livepatch_module is the Nth live patch applied
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Suggested-by: Miroslav Benes <mbenes@suse.cz>
> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

JFYI, the patch has been comitted into livepatching.git,
branch for-6.14/stack-order.

Note that I have updated the version in the ABI
documentation to 6.14.

Best Regards,
Petr


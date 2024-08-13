Return-Path: <live-patching+bounces-483-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD59294FC75
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 05:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7185C283388
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 03:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25AAE224D4;
	Tue, 13 Aug 2024 03:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BTEze8lI"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA6F2033A;
	Tue, 13 Aug 2024 03:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723521237; cv=none; b=qLI98CtoRRya18Mvn65FVKE6avM2Vg9xy7JEjzd1K6e/TkEKuUlzgizpbpmE8xqQqlYIO/ZwjsUDcozC/9GSPvW8Gweqj+FFhVslD2fYUwCvumyP5bzYmAwujy5aeP0zXdlr621aAPJN0zM66SPEeD4vGG9eESDoY06s4Nn8HNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723521237; c=relaxed/simple;
	bh=bzzkOdYjZnt3NwRR0zM1nV4+wHGZRcHbO0WP+1KwHyk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=d7iI7jSoc3KoXhIhr8TCiwiKeN90yFA2jllrH/UnsETBcB1gB6VumgtKGNATJbDwk9b6uS6Q1X5cXnhocgxPQx2/WLFJo9kSTXjY/hrPZ4HuRm93xXTMuzpYpuZU1bRyYNmi0iuf9mIUO6wuSROdb3wDNEyx8BmraYYxA/24LUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BTEze8lI; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5d5c2ac3410so2957249eaf.2;
        Mon, 12 Aug 2024 20:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723521234; x=1724126034; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tN/ZRWVHEHWYN/MyGgywTnPix3p+IROxtn8nqbPNIJA=;
        b=BTEze8lIMGUE4vI7bEJSSERAiU4o6IHNC1i5RakUDRbrYz2e8RiMXb+NmBXwwyjZO9
         FXsgmF4s6qEbD4XfiNIlapGGtHHXC6v6p2dqTNFPJxQ2JhHpEjBKhGpN/u6qPxGpWTYm
         9frvY1AUc2j7K1d5SM8/TPnOkP5H2YSThAPrY8Y0h3LIi2Y85H/mSMLPAcaZOgBf9F2O
         J04DkWpq7dVIOvFTnFgP4yLQkApEENnCujuhxGlstg4x/W5FJCgU86L1/9hK3Iw8T5m3
         CeOE4xH3kMT7eTikwcdDHrJzLNidec6fjnxgZOSLajVEAPXJTHzGDSmkgvp1LN33XaUg
         QnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723521234; x=1724126034;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tN/ZRWVHEHWYN/MyGgywTnPix3p+IROxtn8nqbPNIJA=;
        b=aW/dZ+IYlWNy12yrOn9f8kz4tjjpjaYzwk7TylDy4XSh7B1wMaFhP2xyNlinVqe9My
         g8pgH3xZ/w1U8TwqzDP/TdmmC4OPeo5uP3JgqJR8Bkj+KVCqvm2zsFYuW7oh5f+4ym4w
         7jpTu4rOk6u+T9n9Mpa0x9NFESUxM+RXqUGJh+/u00qwpQoiCyzwQeowsWQZZBsXC7p5
         bNTVhnrjuci82P39OmL20VJsE69LxfHP5Oz6k27Bh6XNvp+qhZpSLInEPgPZIihi/GJJ
         jvPq5/Y4Y1Kn1yDPZ2hBUmI2Dfk7FZRRLWodarm3fSiQK8h6W94QrOm8sQC2OBcmsDOC
         SQ4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVEEQsKfGnG0zItsfeSQL0s5eSmu7QcuewKnmoG0O56pas3tiI+Jm/ZknNj/ggdzVn3RK95n0uKmHIgOglPeA/Gb2K/tOl0DQ0mC9hN
X-Gm-Message-State: AOJu0YxHT9URsKYI9yx0DR3aMFXuHubBoLasrFhhkfEsQf3W5A95Z20e
	KBjo9Yzc9AixA8USi9CRNlaRUUHaUiEAn4N2g916y2KEmxnnjdGurQ1rweuqYsY=
X-Google-Smtp-Source: AGHT+IHhjztVdxVkUJdKWhVnrviol8gwdnN4sAKkYX4+T/qtEtR8vOGPch0tye0D++yzk5zCX6/UWg==
X-Received: by 2002:a05:6359:4ca4:b0:1ac:f144:2b16 with SMTP id e5c5f4694b2df-1b19d2f57e9mr319419355d.26.1723521234390;
        Mon, 12 Aug 2024 20:53:54 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c697a6c5c9sm456591a12.78.2024.08.12.20.53.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2024 20:53:54 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v2 1/1] livepatch: Add using attribute to klp_func for
 using function show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>
Date: Tue, 13 Aug 2024 11:53:37 +0800
Cc: live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <8743E498-1B7D-4E05-9B9D-4A243089BDD3@gmail.com>
References: <20240805064656.40017-1-zhangyongde.zyd@alibaba-inc.com>
 <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Aug 5, 2024, at 14:46, zhangyongde.zyd <zhangwarden@gmail.com> wrote:
> 
> From: Wardenjohn <zhangwarden@gmail.com>
> 
> One system may contains more than one livepatch module. We can see
> which patch is enabled. If some patches applied to one system
> modifing the same function, livepatch will use the function enabled
> on top of the function stack. However, we can not excatly know
> which function of which patch is now enabling.
> 
> This patch introduce one sysfs attribute of "using" to klp_func.
> For example, if there are serval patches  make changes to function
> "meminfo_proc_show", the attribute "enabled" of all the patch is 1.
> With this attribute, we can easily know the version enabling belongs
> to which patch.
> 
> The "using" is set as three state. 0 is disabled, it means that this
> version of function is not used. 1 is running, it means that this
> version of function is now running. -1 is unknown, it means that
> this version of function is under transition, some task is still
> chaning their running version of this function.
> 
> cat /sys/kernel/livepatch/<patch1>/<object1>/<function1,sympos>/using -> 0
> means that the function1 of patch1 is disabled.
> 
> cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> 1
> means that the function1 of patchN is enabled.
> 
> cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> -1
> means that the function1 of patchN is under transition and unknown.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> 

Hi maintainers. How about your suggestions to patch V2?

According to your suggestion, I made some new changes to the V1 patch.

I am waiting for your suggestions. 

Thanks.
Wardenjohn.



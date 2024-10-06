Return-Path: <live-patching+bounces-713-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D12991D4A
	for <lists+live-patching@lfdr.de>; Sun,  6 Oct 2024 10:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A78021F21CDE
	for <lists+live-patching@lfdr.de>; Sun,  6 Oct 2024 08:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02DE170858;
	Sun,  6 Oct 2024 08:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U42dyjA1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6BD16C451;
	Sun,  6 Oct 2024 08:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728203571; cv=none; b=ORAObtL9AC3XcTLjV5rBBgYKVvK3hibX7dfAm8WSpBwAG+rTwCved0iSkFEuhbBXZbmFaoZx08znjxte80eZ6AjkZCv4qpQkGIlbUsSePO2NzS99d4BaPnBc7vEpN/iN9oVzlxWtRho5JmU+QMRk87K645+V/sAK+Z2w9TdnvQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728203571; c=relaxed/simple;
	bh=EcE5kkC/aV04D+38cw9XnaHZcYDrUwly0hGfP3HlXVE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kdmMYuVUnqShV2ZvLqe+wBGP9GEDd50vRXTt12uw0F5LqgIprQ8vSubhNPyCvKlKtCqewET0ZVWjZJHnYGD1zLz6O9Xz506+RZrStPRAgR8dO9Zdd9yGdKL/dB7YP8zvIVCoX38KOM8RPUbsi92Zgv0qfuAwytz5wdO0IeFOsiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U42dyjA1; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20bcae5e482so30094025ad.0;
        Sun, 06 Oct 2024 01:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728203569; x=1728808369; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HYNc/KYuEUWw9uZAUDI4SOR38k7OjxCUwwxBdge0lA=;
        b=U42dyjA1DuXmV0883Z/oF4FMi9N9jNC3epdN6RKLKSSDPWRgsUtb/towig5eaNkMQ2
         hS25cVBPE+wvUkT4jrPR3zU3oXuq9X4mF4OVkX56AJXD73UEha4fAjY+5IQrnD5Am91U
         Q9xggTh+GNYGcG+Eh7PcRSAN8p21i3Zrb6CDSPhy1H+STi5NrQoJNdrPu2rmBfaNqHgp
         NYhIrs8RAsnFDJ80rRxqmPuhaigPaxaoZrkSRyjMX05szBY+u93t99YxvV1Y3PkGbqRK
         4JL0+igV/iLWShI7ReJJfhm1qRhvNOC+iTsxV+85U8GyC7MslHfNBbvFX4HnIkjNbppp
         qDOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728203569; x=1728808369;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+HYNc/KYuEUWw9uZAUDI4SOR38k7OjxCUwwxBdge0lA=;
        b=FrYYQq/C0pGSKMgv1UCnovdh8c5krx9U2K6hNLP6v59wJykK+jy/M9U6nGw54nYdj8
         yu3ZKP0LgnpqCJHbGVjT0qsTyRJaqaTsQm3Vqjh9lTUBVuSBJJ+CTyPt7NR/ZneHqjzr
         dwBzFCBtNPd7XbaTOGMwGp4g+vQl0Lq+3Wrjst/i4J+XnB4Tk/4KuXYgp7lbw74Se4LR
         v4NadwhMt22lcCndtMjKpcMer1Xc9wO0t8jfFkA8d42106C3JnTM0dGFcPbEnde7iYMc
         wY/IBqzyI01ZPnDdrbB5/ItKRIRbVV4yl0eUPE4xiNDjslx9drWmchdLoB0OIBocGb8X
         0f6g==
X-Forwarded-Encrypted: i=1; AJvYcCV4wNFZ4fliWN9DSZhNlmu2k2OklfPTqs209IF8mIcofplUpoEG7Hr8mc1l6x11JUbZBp/vEjsu0WWLh+E=@vger.kernel.org, AJvYcCVPuQd9OJgZTq+kacRqsokZO9SrtZnzpzgGWzQQPwS0JFHROeJKzkMXNFdG0kFx3jO3eoPD0rXQQOyqYcMv0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuGORGSYxgiaFBIOFzLoZMmdL2xff5NVXVrhcFvm3B6Crga0FK
	aiW9eQSKYOMEcMQ064e93cvC0ug4EfAIWs3UL/e1SPX1oQLsOvb+99zt7N6zJTs=
X-Google-Smtp-Source: AGHT+IH8JPzFFA9Qy0/ZGmPAeHCuUUjxqcHrPAi9XSp9Els6hlOWzwN4gCdOkPxPxi41vC3OXNKrCQ==
X-Received: by 2002:a17:902:dac7:b0:20c:2e8:9bb7 with SMTP id d9443c01a7336-20c02e89ca4mr114633485ad.36.1728203569501;
        Sun, 06 Oct 2024 01:32:49 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e9f681f0dcsm2843091a12.24.2024.10.06.01.32.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2024 01:32:49 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH V3 1/1] livepatch: Add "stack_order" sysfs attribute
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20241003152516.fzga2uaivzg57q4s@treble>
Date: Sun, 6 Oct 2024 16:32:34 +0800
Cc: Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <9E708EDA-C28E-40BB-8B5F-703132E95096@gmail.com>
References: <20240929144335.40637-1-zhangwarden@gmail.com>
 <20240929144335.40637-2-zhangwarden@gmail.com>
 <20240930232600.ku2zkttvvkxngdmc@treble>
 <14D5E109-9389-47E7-A3D6-557B85452495@gmail.com>
 <Zv6FjZL1VgiRkyaP@pathway.suse.cz>
 <A7799C9D-52EF-4C9A-9C22-1B98AAAD997A@gmail.com>
 <20241003152516.fzga2uaivzg57q4s@treble>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Oct 3, 2024, at 23:25, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> 
> On Thu, Oct 03, 2024 at 10:59:11PM +0800, zhang warden wrote:
>>> This attribute specifies the sequence in which live patch modules
>>> are applied to the system. If multiple live patches modify the same
>>> function, the implementation with the highest stack order is used,
>>> unless a transition is currently in progress.
>> 
>> This description looks good to me. What's the suggestion of 
>> other maintainers ?
> 
> I like it, though "highest stack order" is still a bit arbitrary, since
> the highest stack order is actually the lowest number.
> 
> -- 
> Josh

How about:

This attribute specifies the sequence in which live patch module 
are applied to the system. If multiple live patches modify the same
function, the implementation with the biggest 'stack_order' number
is used, unless a transition is currently in progress.

Regards.
Wardenjohn.


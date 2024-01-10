Return-Path: <live-patching+bounces-130-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E182C82A023
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 19:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BF81B23FB7
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 18:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00894D59D;
	Wed, 10 Jan 2024 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="THvjTnTV"
X-Original-To: live-patching@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D3C4CDFD;
	Wed, 10 Jan 2024 18:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Received: from localhost (unknown [IPv6:2601:280:5e00:7e19::646])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 55A8480F;
	Wed, 10 Jan 2024 18:15:58 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 55A8480F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1704910558; bh=F9aP0ah87Xk7AZUtSmoYcWJrjtch3ZMm7DHogkmWg0s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=THvjTnTVaoCqe8d2FXz90MpJeTeT+HRfV7b8FwejUMuaYBfV7w06dwrd2ilR5LY2+
	 nbICsJO1YZCn5U4mLM0sIWe5R+PwXKKKucOQzsjMcVJ6dVefiOSWBoSbcu+1p0+q+p
	 k3alrXY8jWxvuq98n+aMtqRGBwtZwkQjLKkz1x1ivsE9mRBGrbcMztFz5WPolucPYy
	 chpqJIDXig94DtvuLSqQzXnW5JzGweFuRtr1RgyKQLuqbn10KHWgFMU4Kv/iv1cgwx
	 l8TB+SlNTl4teXyaCbDmdXMpBN7B2nqFt/4xp8sS1TzJcE/l2GcTXar2EMlsDXbHyb
	 hDRxNL+54A57A==
From: Jonathan Corbet <corbet@lwn.net>
To: Attreyee M <tintinm2017@gmail.com>, Bagas Sanjaya <bagasdotme@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation/livepatch: Update terminology in livepatch
In-Reply-To: <CAJjsb4reD_TVWRFonp90xXD4Ye2OOfOd894PzmfMKaP3qFkbYg@mail.gmail.com>
References: <20231223205813.32083-1-tintinm2017@gmail.com>
 <87o7eg607d.fsf@meer.lwn.net> <ZYpb6Woh45ZnEvCP@archie.me>
 <CAJjsb4reD_TVWRFonp90xXD4Ye2OOfOd894PzmfMKaP3qFkbYg@mail.gmail.com>
Date: Wed, 10 Jan 2024 11:15:57 -0700
Message-ID: <87jzohoy02.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Attreyee M <tintinm2017@gmail.com> writes:

> Hello maintainers, 
>
> I wanted to ask if this patch of mine is accepted as of now. 

You never responded to the question that is still quoted in your
(unfortunately top-posted) email:

> So this is a classic example of saying what you have done, but not why.
> What makes this a change that we want?

So no, not accepted.  Even with a proper changelog, though, I'm not sure
I see the value in that particular change.

jon


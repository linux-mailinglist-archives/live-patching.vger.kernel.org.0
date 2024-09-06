Return-Path: <live-patching+bounces-624-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57F7696F9AC
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 19:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 843981C218C2
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 17:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D07DA1D4141;
	Fri,  6 Sep 2024 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r6Ahdm7b"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92751D2206;
	Fri,  6 Sep 2024 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725642013; cv=none; b=t3q3z+lPHUntuuLmCr4alRNSKW6A44vBwQZoOxFqXfRXNVOL04264y59q62ZIL97e3MiHgoVwQuvb/UhMP4wmkAKU7DBl4Bf1+XTXsYBO5t/P4lwaFm7jhx4TxL97xk2C+x23F9JKvOXgNT7QGiHQ9HC0LWdPl4d500Cz2zWJ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725642013; c=relaxed/simple;
	bh=NpvgJcN6Nc1nLVpUDjfrpwklDMw9BsRKW10b4VcoGMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HLaW0gMdJ4xT813yNOjVR9hQCTkrLobCPIy42l5jX+XEfljV52vsUeZb/EP2OB0MfBne4ZzaQqKjU5DufjO4/ezOmei1MShixNx/rol4VqDgRfyjFOUXAycKv3utKZ4w0EefJ1WUeDoqwk4NlY3f2dVe5/NTgI3BVEqfa+RSkLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r6Ahdm7b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AABC4CEC4;
	Fri,  6 Sep 2024 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725642013;
	bh=NpvgJcN6Nc1nLVpUDjfrpwklDMw9BsRKW10b4VcoGMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r6Ahdm7b31Ws6PAiRLu4U/NwtqQrBsP4VRHt3o3JgYkV0uqDYzqH8FkJpuDYU5hqP
	 ddtDaqV5v+G54Rz41Q3yA6ar2XsPL3NdCvp9ZyCLpzHsT/AxLzAm5oZdxL4MqPysHJ
	 AZq7TXocb0P8GuGCphwj3mU0GdCXeOYdD5KtTKJpti2tpwZYKnrInL+KaGej/3D+CW
	 yzZTdEApt+w73xc3kbFuGHPdieYxpJrAyX4sNq3A9FPw3PxWv00Ig4WkNrLcoKE9xJ
	 /kzcdcLPqsEHsDFBvSa014deNXNPAGZdYTouVkRnasz8fRG9Np1390e2lkmO2fUROZ
	 8A+v5je7vYxQA==
Date: Fri, 6 Sep 2024 10:00:08 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240906170008.fc7h3vqdpwnkok3b@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <ZtsJ9qIPcADVce2i@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZtsJ9qIPcADVce2i@redhat.com>

On Fri, Sep 06, 2024 at 09:56:06AM -0400, Joe Lawrence wrote:
> In the case of klp-diff.c, adding #include <string.h> will provide the
> memmem prototype.  For both files, I needed to #define _GNU_SOURCE for
> that prototype though.
> 
> For the other complaint, I just set struct instruction *dest_insn = NULL
> at the top of the for loop, but perhaps the code could be refactored to
> clarify the situation to the compiler if you prefer not to do that.

Thanks!  I'll get these fixed up.

-- 
Josh


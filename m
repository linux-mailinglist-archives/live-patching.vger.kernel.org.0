Return-Path: <live-patching+bounces-233-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 081AC8BBE2F
	for <lists+live-patching@lfdr.de>; Sat,  4 May 2024 23:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94F0B1F2186C
	for <lists+live-patching@lfdr.de>; Sat,  4 May 2024 21:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E7E757F5;
	Sat,  4 May 2024 21:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4m6r/3Ni"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E591BF3F;
	Sat,  4 May 2024 21:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714858590; cv=none; b=PvtWuKsW5ZWX0iR1BcIkyH4rFuoP+z9wltCEL87Fh+Tpm5BZtfivkqCLE+wimGzTYtcyhmLgV1zMy/zWM9NBtjhCHomIc1kuQYDiEQX3o9PiSbc24oY3ix/ved5ehsE9MFdzwvYH2GgM/rXE+vBsMLSMpI2f6Oa0+W3jAsAD9EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714858590; c=relaxed/simple;
	bh=ZnNxItLQ99HndH5ssS8AGuJNbilZX0Y4yhaX2FXBZBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwV0KFhiQs2r0McfFfw8dZQ7mwnQsYlQWCB7VGlM2ZiApgMi1VHT+ciqWdMT5owHUEQalLLBM2fMy6kLceiUSuGekg/4L7nZ7zkxUWWICuEsWs842JW5K0qtOI1uxRpduV8nDbY9Cd29sXuaqCaX0V1IO8Cuu9ciaD4H2RckLiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4m6r/3Ni; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=au3CRqg1qLgLTS+9BrMJ50BLUPynfS1+H/N0EH8XWGc=; b=4m6r/3NiJE3SR/mby2ynMQjbY7
	DphJ51ygvpO0NXDG44P+9ROxfOBdIwzwyOr29zArw+CInr4YAEt4Xy6jrJPJha1s1G9Z+GB/JPhih
	94HEpsWFlKJ+9OWYwmfMLt3IHb7J/w54Sf0QtxOSX1aF39lXr6MH+MdNHe777ORCjYCjHNt92+G++
	LXpBw8SmkdqF8zukGqi5PWNHRDLHOwhXPdfzXZtCYY3gBk/PE+u4qVqEbNjeFlY5fqaVuuP/GjaKF
	Ae1FhtdiosfZhS8RKYmLToKqNMhlC8kwdGrzfj3X3f/YEqkDcAvFNduuadtk2vNw1cRVefKyu9Ggs
	4BJ+tdCw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s3N3Q-00000002uBp-3TT7;
	Sat, 04 May 2024 21:36:24 +0000
Date: Sat, 4 May 2024 14:36:24 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, Greg KH <gregkh@linuxfoundation.org>,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 1/2] module: Add a new helper delete_module()
Message-ID: <ZjaqWIxJIDepaWof@bombadil.infradead.org>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-2-laoar.shao@gmail.com>
 <CALOAHbDGcY5y6hWZgJp9ELrt_w4pfB-X3EqS3yu8k37pj3ZEcw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbDGcY5y6hWZgJp9ELrt_w4pfB-X3EqS3yu8k37pj3ZEcw@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Apr 24, 2024 at 08:09:05PM +0800, Yafang Shao wrote:
> Luis, Greg,
> 
> Since the last version, there hasn't been any response. Would you mind
> taking a moment to review it and provide your feedback on the
> kernel/module changes?

Josh had feedback for you. Without any Acked-by from livepatch folks this
isn't capturing the full picture.

  Luis


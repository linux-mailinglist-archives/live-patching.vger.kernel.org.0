Return-Path: <live-patching+bounces-584-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04F6C96B29A
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 09:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5A0128206A
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 07:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96DF01487CE;
	Wed,  4 Sep 2024 07:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sLxCoBjN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F522137775;
	Wed,  4 Sep 2024 07:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725434066; cv=none; b=gG6hDivnfexbkhgtHRJB28ny60tV3mXDWgsSgg6f8ukD77qioNrbiRVUyO09xD1e95Ff6+6W8ydfqAVxOmRKoIlbznb95RxBmXCRIrl9GkwVUFxES8FfjtjM/agEssxqJ4IWaS9vCWBuhfNHaWz82HN/LATbMcHFUFECcbl5kkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725434066; c=relaxed/simple;
	bh=KN1kLmCYeiIi84t/nlggKttqgFeRahc7YP7pb6dMGzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AYBC8cjH/R9vLu7W5GKAXQ2C2GtAtoHpP55jl6qg3dq7MNiDyv1SXkIc2xFbMqTqdMZVZ5o2bZAL6pQv7LeQMtgheBG9rvc3nI6yLg79sObhINmfUjE0V74u3ZZ4+a0OvlLMuBKqCWUzVpWXdhbbzZokXvct5zpl7DTcA1EgAdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sLxCoBjN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0022CC4CEC2;
	Wed,  4 Sep 2024 07:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725434066;
	bh=KN1kLmCYeiIi84t/nlggKttqgFeRahc7YP7pb6dMGzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sLxCoBjNr+sp5aeD0Ucf5Uwx+MV53/UQtfTN72yKtaVqTr4Owj7SAdJ3iL5PiJrCq
	 XXX4l7easTE7cS8+5oFJf2mFg/4b5dyRXvb6sNjBPczDHVWSq5vnCiiSAgYnmkoMNR
	 GGQc/AnpZaw8AmOUj52OIU75TmUAx/VOxoRXqUIGCJVkDEvMGh+jQUJgpfzyFYACUZ
	 uvwS3J/xdtsXGFa8gyMUdxBPlHdwz6yeH2m8IXKdTpjkjAYELaYFeLcUhm8lgmw6uY
	 QkUiFAM6dGBlG8P4x7dNt973frd/TNwH8YVPcuqc4QBKD7DXz3IhN6LD+nr7BlOEIN
	 +qYwYA1mjPCYQ==
Date: Wed, 4 Sep 2024 00:14:24 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: zhang warden <zhangwarden@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Jiri Kosina <jikos@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
Message-ID: <20240904071424.lmonwdbq5clw7kb7@treble>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <20240904044807.nnfqlku5hnq5sx3m@treble>
 <AAD198C9-210E-4E31-8FD7-270C39A974A8@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AAD198C9-210E-4E31-8FD7-270C39A974A8@gmail.com>

On Wed, Sep 04, 2024 at 02:34:44PM +0800, zhang warden wrote:
> In the scenario where multiple people work together to maintain the
> same system, or a long time running system, the patch sets will
> inevitably be cumulative. I think kernel can maintain and tell user
> this most accurate information by one sysfs interface.

If there are multiple people applying patches independently from each
other (to the same function even!), you are playing with fire, as there
could easily be implicit dependencies and conflicts between the patches.

-- 
Josh


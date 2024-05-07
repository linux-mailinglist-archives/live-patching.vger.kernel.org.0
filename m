Return-Path: <live-patching+bounces-245-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0845E8BD977
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 04:41:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B19291F22A5D
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 02:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD1168F59;
	Tue,  7 May 2024 02:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfOM/Uz8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52D24A12;
	Tue,  7 May 2024 02:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715049713; cv=none; b=N2dcn76dzMUcWW4BsUiqqYmQ7zjDTF7P55ZAlpcGK6v34THclnsl/J0nQwg3+MyLZmCE3KZBu5EOft0euzR8o2R/aF31IVsLytPVYZ8V3oMFUTZnYPEiL9qvvnvAsXn5hM9NNVs9ZHs1BaSIJ6Dl+H6ghapj+xT2W04YVK965GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715049713; c=relaxed/simple;
	bh=5ZbJZ+MRgMQv8oPdoPolCY3a9EiStO8pBdLRaT33Z80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=smAjssC6bHmBP6HYi3xZd5j6GkrbT3hW/v5CcqYs02TgHp5lt624gssH6gSUHuL45wp16iZk18AQAIVnwOlQm4Nv36nXo/JtMiN7Tf7O5Jh6GJlGYKRGZHWtN2BDjd2PWCVNh9JliH6WLoo4ZUTTpAfBweNSvEC2cV0wmGaUZC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfOM/Uz8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88D7C116B1;
	Tue,  7 May 2024 02:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715049713;
	bh=5ZbJZ+MRgMQv8oPdoPolCY3a9EiStO8pBdLRaT33Z80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KfOM/Uz8fc1oVzZbLOVKGH4oSHS+lpvtE2r/SffaTnqzIKzkIcdGTfMIgNZVEBCw3
	 5V1hINuVVnZRW0tkyLNE1SbXy1gjxpwLTPuzpeKso5J7LZGnvzCrJb8EfVz5xSgIj5
	 d2QhVTVreshqWrB06cQ0WAmddHzIdOWZfu7fROniQ0GGWUlfyyI5lQzcteJWCUB6hm
	 vY0+Y1wGF+2E4FZUWNduEBSJYJxa0t/Bu2gz/mW5i1CiFSpnkIZxZITTOO59Yzezl8
	 Zl7wrahmNZUT4mD0DmQv8gAxpJ4WgB3Wenc8jxq3Z7dhuoKvRqeGaw8ObNJ9o/oltN
	 38YJKO6+tGndA==
Date: Mon, 6 May 2024 19:41:51 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: zhang warden <zhangwarden@gmail.com>
Cc: mbenes@suse.cz, jikos@kernel.org, Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] *** Replace KLP_* to KLP_TRANSITION_* ***
Message-ID: <20240507024151.6jto4zraqfbqxcw2@treble>
References: <20240507021714.29689-1-zhangwarden@gmail.com>
 <0E399FCD-396E-448B-A974-6034F4CF2B53@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0E399FCD-396E-448B-A974-6034F4CF2B53@gmail.com>

On Tue, May 07, 2024 at 10:21:40AM +0800, zhang warden wrote:
> 
> 
> > 
> > transition state. With this marcos renamed, comments are not 
> > necessary at this point.
> > 
> Sorry for my careless, the comment still remains in the code. However,
> comment in the code do no harms here. Maybe it can be kept.

The comments aren't actually correct.

For example, KLP_TRANSITION_UNPATCHED doesn't always mean "transitioning
to unpatched state".  Sometimes it means "transitioning *from* unpatched
state".

-- 
Josh


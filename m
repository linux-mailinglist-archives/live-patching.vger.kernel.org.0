Return-Path: <live-patching+bounces-659-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B48978BBD
	for <lists+live-patching@lfdr.de>; Sat, 14 Sep 2024 01:16:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6CDC1F262B8
	for <lists+live-patching@lfdr.de>; Fri, 13 Sep 2024 23:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A66F9155333;
	Fri, 13 Sep 2024 23:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OhUA3gij"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7941F762DF;
	Fri, 13 Sep 2024 23:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726269387; cv=none; b=o83Pp6bDGuX9zZQnlixcm3ONBf19YOTWCRDkKFv1i6M3nxasbUIOjpkHpWrWdt+FDTeO37cC3dJMiXKHchfzbPKo+Wjb82+pqKbS2GaVKt5MRC//lOH1cKFylSwOhuOFLGkLZ+jX2bV3kEAAeWRNMwqKRUDEGk3o1n7/cb7gTxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726269387; c=relaxed/simple;
	bh=3a8aWpkzAl0PoKFm2ghjkav7sAK3XGdYsuU7/51Mb50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ep2GN9BpJ6AKz/lu0bcsGG3Qedc6oV+yWAs0HSGdzhZm5ZzAJGIPAv3NOGU7rSr4q9+UmTT/gQ0JPPMWEydrM7sXXnYBZmOSk6snKPnXQO1xY+cJlOzZfxf7ERQVpqy3oYSMg8cPLXMpg3Xa2LD5DFRsnDi++y9yIbdqUHy6VIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OhUA3gij; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED6EC4CEC0;
	Fri, 13 Sep 2024 23:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726269387;
	bh=3a8aWpkzAl0PoKFm2ghjkav7sAK3XGdYsuU7/51Mb50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OhUA3gij4XNbe2IwtN2mcDrFL4xI03lSJA2psN02zIZ95Fj3rJbczwasSSmLmQRKY
	 wjeTYheKxcS/9/lH5N8IOM93h034tTuZnFb2CiTlqWnhX034HOkY0iN8KMV7rZUtWU
	 RN7K8UwsDLzOCZF/68XhOtXjLo7PvluwpIVxQBYnA+x96/QlFaSyZ5lMQDqUKfuHMN
	 Ya1pAJe4e7uP6SseEbZdfh7mh63ruRc0eQ4DDlGjSSvwe7W9EdNPB9eIIjzR0l8jdd
	 6A5gbDu7zluW+R+dhZRR0MryN49mihFTiVfgpslxzpK1INGmS/Za97qdGQXhik4pOd
	 Jx3TXaUC5frCw==
Date: Fri, 13 Sep 2024 16:16:21 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Lukas Hruska <lhruska@suse.cz>, pmladek@suse.com, mbenes@suse.cz,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, mpdesouza@suse.com
Subject: Re: [PATCH v3 0/6] livepatch: klp-convert tool - Minimal version
Message-ID: <20240913231621.cksub3pycu4fzl3s@treble>
References: <20240827123052.9002-1-lhruska@suse.cz>
 <ZuMFfJkCkZ4+9505@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZuMFfJkCkZ4+9505@redhat.com>

On Thu, Sep 12, 2024 at 11:15:08AM -0400, Joe Lawrence wrote:
> Anyway, now we have two RFC / patchsets supporting in-tree creation of
> klp-relocations (klp-convert and Josh's objtool patchset).  I think we
> need to figure out whether one precludes the other, can they co-exist,
> or does that even make sense.

I haven't really thought about it, but it *might* be possible for
klp-build to use klp-convert.  I'll look at it more when I get a chance.

> Since LPC is right around the corner, does it make sense for folks to
> sync up at some point and talk pros/cons to various approaches?  We
> don't have a microconference this year, but perhaps over lunch or beers?

Sure...  or maybe at one of the evening events.

-- 
Josh


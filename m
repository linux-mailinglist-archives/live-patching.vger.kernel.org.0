Return-Path: <live-patching+bounces-594-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F5596C392
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 18:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F7B51C20974
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 16:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B14D1DFE2A;
	Wed,  4 Sep 2024 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZH+INkP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005791DEFC2;
	Wed,  4 Sep 2024 16:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725466296; cv=none; b=WyV9lC+Lna6/1xxYzxPg3Yw00m9FnwNGQXTT+RBD8kl5z1fsPPYvVn1xxaCPuCA5X/rdn0J/OV9txxZUYEPIr81icGRnc8VMfmLpCDSgYOB18zZN5EQ3NDL5chZ9obMORVNaI2LpRUtTIGaKx397765thgYFDyDF2/cmGiF0fjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725466296; c=relaxed/simple;
	bh=UWGyaresD4rjeUZpwxnfAeQIXmjnQFTB8ym30NM3pqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icRydKIh1hLgYPjoxcgS8wVl9PD9rqzgTw1ZaMVXxeoUbBXSnfTGCEU1wZYUUjX0U4VVYF5Xb8nbd06Y0pL/sFrarmLeUwtGGoRJJtvmJb1+lRKgVdButNhHBmt4kYhMoSRONMrb8zyJE/jjqMYWwL57ULFhUJZl6O5fhEqk+JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZH+INkP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142AFC4CEC5;
	Wed,  4 Sep 2024 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725466295;
	bh=UWGyaresD4rjeUZpwxnfAeQIXmjnQFTB8ym30NM3pqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TZH+INkP9NA+KuMNBX5emvTd+JmWWU7qSOowAVli9eVNf/U3KuPNbZ5l4xO/Q46yP
	 qPjzsU200XAen/EL66p2Vsrr50PnXMZqu9i6mU/+A3q13mbktQYyao2U9OA5AsMv60
	 n4k6vsZGDa5ya39I/n3jJsAiFu7w9FeRm8bNjjRFBqqnTG3A2Ihd1u1NY0WMD//MeK
	 ujcmu/05aS2C8v9VUJDdYmEqMkQ0FiFAUUng06MiXmvMqo3SmRkBcqYLw9ZH8tJtrD
	 OJJWub1wLxGjWdTWW4p91+Gyb+0fQ8GuXyqMdZOssABVWs1d/BVE5CEK75RTiyHusB
	 5yygtxl2PJuZg==
Date: Wed, 4 Sep 2024 09:11:33 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 29/31] objtool: Calculate function checksums
Message-ID: <20240904161133.oyjuwjrm4rjdfivx@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <ffe8cd49f291ab710573616ae1d9ff762405287e.1725334260.git.jpoimboe@kernel.org>
 <20240904075433.GD4723@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240904075433.GD4723@noisy.programming.kicks-ass.net>

On Wed, Sep 04, 2024 at 09:54:33AM +0200, Peter Zijlstra wrote:
> > +LIBXXHASH_FLAGS := $(shell $(HOSTPKG_CONFIG) libxxhash --cflags 2>/dev/null)
> > +LIBXXHASH_LIBS  := $(shell $(HOSTPKG_CONFIG) libxxhash --libs 2>/dev/null || echo -lxxhash)
> 
> This was not installed on my system and I got a nasty build fail. Should
> we make all this depend on CONFIG_LIVEPATCH or force world+dog to
> install this as yet another kernel build dependency?

Hm, that would be nice, but as of now the objtool build is independent
of the CONFIG stuff and I'm not sure how to integrate them cleanly.

Maybe it could only link to the library if it exists, and then complain
later at runtime when the feature gets specified on the cmdline?

Or we could try dlopen?

-- 
Josh


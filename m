Return-Path: <live-patching+bounces-1839-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id DD492C53684
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 17:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A7B16353DE2
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 16:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA50A33F39A;
	Wed, 12 Nov 2025 16:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B25wvQ9+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E2933B6C7;
	Wed, 12 Nov 2025 16:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762964223; cv=none; b=ik0zZwQLRW4RAV37+MzZqjGtBlCvAKtMcrSEX4uGm1f0V6c+golKc1RqWwQicUg/uCO5uGWmmQ+fVdQoslDe0fpQXkTNOgvE407g4Q/E+8TuMha1mO8D3a1tHVNCoLAa3KjOEYKbgFPPwdUyZmrb//hLwjoD73lXqI1MnNji9gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762964223; c=relaxed/simple;
	bh=W2l3+H8ymy0NT/G1IzznrxCb71B9p0Ps4vJJz4dz0Rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HXeUNTS5C/o1vOs7FVF4IzlJ4B3XMqDaMb2Wq5Gt/UG/FOTqOsOCES8vO9zcVwUNoMprldYGZ6VMukjQzGESJOzuT+o7KlWPv0irQEd9v4P0aYQJcUl3nhYHrGgQJNM4RP59pCZKL9X4gp8oLdb2qrcDaiZu4qB1QZkhVR8iCvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B25wvQ9+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FE1C113D0;
	Wed, 12 Nov 2025 16:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762964222;
	bh=W2l3+H8ymy0NT/G1IzznrxCb71B9p0Ps4vJJz4dz0Rs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B25wvQ9+eBDQyWi5SXAGM+wvlXclFB28uSNzMXnw2EcjlnSbgfU/bTRUCsIzptFjb
	 KHi6EM6xBAJ4U4u/HvE/GyZnqBwFyjm4NOhPo0K1hqlzP1xqG/hVpzyRtUkkhn0MNo
	 UH78gpQ4ZdSPRn9JJU1CHL9nAyjG6YjZInqO+HBRDKpC9Qt/I9zE5UOedqHksZyFLD
	 dtFSZOMAEBGgB4Kg1NZlJ4+UAapAk7B/Gzao0WLnsQbI0ovwhrz3+iFEUKP2Ighqn0
	 yEI4lp/VYvYr/r/Nb0drQVpotWM+aCfbULHrBOrE02O0iiuEiwbcKtIJoZj8fZ31Ir
	 et9+XdjOAxd/A==
Date: Wed, 12 Nov 2025 08:16:59 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>, 
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, 
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Message-ID: <tujcypul6y3kmgwbrljozyce7lromotvgaoql26c6tdjnqk4r6@yycdxcvj2knz>
References: <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
 <SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
 <SN6PR02MB41574AD398AD3DE26DB3D23BD4C5A@SN6PR02MB4157.namprd02.prod.outlook.com>
 <6msqczigbcypeclqlgzgtqew7pddmuu6xxrjli2rna22hul5j4@rc6tyxme34rc>
 <SN6PR02MB4157212C49D6A6E2AFE0CAA9D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <SN6PR02MB4157F236604B6780327E6B43D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <yk3ku4ud35rsrfwzvuqnrcnwogwngqlmc3otxrnoqefb47ajm7@orl5gcxuwrme>
 <BN7PR02MB414887B3CA73281177406A5BD4CCA@BN7PR02MB4148.namprd02.prod.outlook.com>
 <20251112132557.6928f799@pumpkin>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251112132557.6928f799@pumpkin>

On Wed, Nov 12, 2025 at 01:25:57PM +0000, David Laight wrote:
> On Wed, 12 Nov 2025 04:32:02 +0000 Michael Kelley <mhklinux@outlook.com> wrote:
> > From: Josh Poimboeuf <jpoimboe@kernel.org> Sent: Tuesday, November 11, 2025 8:04 PM
> > > On Wed, Nov 12, 2025 at 02:26:18AM +0000, Michael Kelley wrote:  
> > > > > 2) With make v4.2.1 on my Ubuntu 20.04 system, the "#" character in the
> > > > > "#include" added to the echo command is problematic. "make" seems to be
> > > > > treating it as a comment character, though I'm not 100% sure of that
> > > > > interpretation. Regardless, the "#" causes a syntax error in the "make" shell
> > > > > command. Adding a backslash before the "#" solves that problem. On an Ubuntu
> > > > > 24.04 system with make v4.3, the "#" does not cause any problems. (I tried to put
> > > > > make 4.3 on my Ubuntu 20.04 system, but ran into library compatibility problems
> > > > > so I wasn’t able to definitively confirm that it is the make version that changes the
> > > > > handling of the "#"). Unfortunately, adding the backslash before the # does *not*
> > > > > work with make v4.3. The backslash becomes part of the C source code sent to
> > > > > gcc, which barfs. I don't immediately have a suggestion on how to resolve this
> > > > > in a way that is compatible across make versions.  
> > > >
> > > > Using "\043" instead of the "#" is a compatible solution that works in make
> > > > v4.2.1 and v4.3 and presumably all other versions as well.  
> > > 
> > > Hm... I've seen similar portability issues with "," for which we had to
> > > change it to "$(comma)" which magically worked for some reason that I am
> > > forgetting.
> > > 
> > > Does "$(pound)" work?  This seems to work here:
> 
> Please not 'pound' - that is the uk currency symbol (not what US greengrocers
> scrawl for lb).

While I do call it the "pound sign", I can't take the credit/blame for
that name it as the variable already exists.

It's better than "hashtag" which is what my kids call it :-/

-- 
Josh


Return-Path: <live-patching+bounces-1833-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FBBCC4FAAF
	for <lists+live-patching@lfdr.de>; Tue, 11 Nov 2025 21:09:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 769B83B2E3F
	for <lists+live-patching@lfdr.de>; Tue, 11 Nov 2025 20:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BEA3A8D68;
	Tue, 11 Nov 2025 20:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0xX4xHB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B21627A917;
	Tue, 11 Nov 2025 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762891764; cv=none; b=mjMdfv+x2F0m1tO45YqFbyaHCuMlP0ySEHk+Zfn1gDi6YeUbX8sQi84C2H56CMv4fJpTsLn9h1Iru692/o920XIQS1Nr9qxYAU/f7a4TxQafaOnzORn0X0iIBTi9KgtZgZzpR9fFG5QzdrI4vFb8zf7Y8XyVU1X3mNlsoG2qlmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762891764; c=relaxed/simple;
	bh=81r8gap8lts5uak30gQAcCTFGWaMYpTnRZ3FoD26fSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlbuJauxB6ifAuJQKf12iALz8yMHQaSfZcpvqgKZeLkeoE/Q1liBIhFIgcrAsIYxrgZSxFrqYDA2WVI4RKtPf3WLmTmqXo5hlS3QBtEAkkj2ojhEAn9qULYXljwDLDEDHcRB1moszAm+fVQv4j3dS4ntfdoj0YbM7I0XiM+otv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0xX4xHB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CDEC4CEF7;
	Tue, 11 Nov 2025 20:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762891763;
	bh=81r8gap8lts5uak30gQAcCTFGWaMYpTnRZ3FoD26fSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K0xX4xHBtck7k9JBhThfM+d3aYEb5MUt4SThJqw70cU9CCX8JcFVdGRnhNo4Smo5k
	 ZhF6hQdpnK/xAwpYyI3a3ooBZFmmD1PYEmsHzdNenKgZFNGvPX9e7PZvMf0duoqdpQ
	 CHtA/XF7lhmx6U9GrRUxX19am0ytMRMIKMrwSve6Y227wbQFLODi5tjSpqDzOln5Fd
	 3lpJ0200TzZWsh4k6XBJprgVLsTxbcN14NORlhPJH93I9yKsA4JGd5P7ip9u4JjQsn
	 VQs28VFvnhXhZe82JiTaIjbWCZTR3X8jUdzYn1i5J6KZ6KGn8assRtIwOXU+P+EMfy
	 aa1VeuLUDWE1A==
Date: Tue, 11 Nov 2025 12:09:20 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Michael Kelley <mhklinux@outlook.com>
Cc: "x86@kernel.org" <x86@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, 
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Message-ID: <6msqczigbcypeclqlgzgtqew7pddmuu6xxrjli2rna22hul5j4@rc6tyxme34rc>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
 <SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
 <SN6PR02MB41574AD398AD3DE26DB3D23BD4C5A@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SN6PR02MB41574AD398AD3DE26DB3D23BD4C5A@SN6PR02MB4157.namprd02.prod.outlook.com>

On Wed, Nov 05, 2025 at 03:22:58PM +0000, Michael Kelley wrote:
> > Thanks for reporting that.  I suppose something like the below would work?
> > 
> > Though, maybe the missing xxhash shouldn't fail the build at all.  It's
> > really only needed for people who are actually trying to run klp-build.
> > I may look at improving that.
> 
> Yes, that would probably be better.
> 
> > 
> > diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
> > index 48928c9bebef1..8b95166b31602 100644
> > --- a/tools/objtool/Makefile
> > +++ b/tools/objtool/Makefile
> > @@ -12,7 +12,7 @@ ifeq ($(SRCARCH),loongarch)
> >  endif
> > 
> >  ifeq ($(ARCH_HAS_KLP),y)
> > -	HAVE_XXHASH = $(shell echo "int main() {}" | \
> > +	HAVE_XXHASH = $(shell echo -e "#include <xxhash.h>\nXXH3_state_t *state;int main() {}" | \
> >  		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
> >  	ifeq ($(HAVE_XXHASH),y)
> >  		BUILD_KLP	 := y
> 
> Indeed this is what I had in mind for the enhanced check. But the above
> gets a syntax error:
> 
> Makefile:15: *** unterminated call to function 'shell': missing ')'.  Stop.
> make[4]: *** [Makefile:73: objtool] Error 2
>
> As a debugging experiment, adding only the -e option to the existing code
> like this shouldn't affect anything, 
> 
> 	HAVE_XXHASH = $(shell echo -e "int main() {}" | \
> 
> but it causes HAVE_XXHASH to always be 'n' even if the xxhash library
> is present. So the -e option is somehow fouling things up.
> 
> Running the equivalent interactively at a 'bash' prompt works as expected.
> And your proposed patch works correctly in an interactive bash. So
> something weird is happening in the context of make's shell function,
> and I haven't been able to figure out what it is.
> 
> Do you get the same failures? Or is this some kind of problem with
> my environment?  I've got GNU make version 4.2.1.

That's weird, it builds fine for me.  I have GNU make 4.4.1.

-- 
Josh


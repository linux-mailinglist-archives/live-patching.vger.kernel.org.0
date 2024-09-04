Return-Path: <live-patching+bounces-575-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF87A96AE86
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 04:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D70A286955
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 02:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CB8335D3;
	Wed,  4 Sep 2024 02:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDE8799W"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1617BE49;
	Wed,  4 Sep 2024 02:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725416712; cv=none; b=XqZUiPikmhiwxJyJm4OwNOTEvYkinpbe7Gj3whyDjVCeKUCd9NfKW8aSaF0XVwi5sr0zFitbJ8/jUctAl3Ojl8BF42b/+yj4Vlo4CcEIx3LoRD8MCvd1gTtdRUQ9obhpyPGcdaGXzR1RaUx86sfHrrx7kia+SvCAa+tK89aaR1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725416712; c=relaxed/simple;
	bh=S8VVGSChyr09gjPcr3VhpFJQ+BWJbA82d5f8YVfDUCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uFHPHTKMcugZcdV0v1dl4rvH2XFthwg3LfIvjZcyTWzkBcE7tlZnJaqKA/gd94I8h7YBomdXLkjzw86/f+1bUI4Xo56uX+y/XG/B//o9r76DpD6EQMiLE4bVQzxMEzL12ohUmxe/Mt/wPNJVBkYpdFECYtS15tzWir0yVuybdz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDE8799W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAA1C4CEC4;
	Wed,  4 Sep 2024 02:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725416712;
	bh=S8VVGSChyr09gjPcr3VhpFJQ+BWJbA82d5f8YVfDUCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VDE8799WS8lCqg47skM4z24dyLt4FlvQ36pJPVwRqG8ZjIenHvRUTcBzzZszGgjYx
	 C7nam6gQ4oOQof3UliSrOgpCN7Rjpe25GUWjJfoVTKrbOjCw0ms+NbA1qZ5CMDxe+u
	 aR1T+NBUYBG/9LPUxIl7x/hsHrCyGRUCdlEbdiv+9lYsq4XpJ6W+5FwR/ZIaQMaCBy
	 Mv83q7oxjx9Ceu4c9ckW3DCOtnYqpJ3dkg7q/fRyGPh8RaAvfjTr8xgS1oTKW0tS2A
	 s4V13z7t3F+7R7ckZtRSdQjHWjSgUFdAPqzyw6Q11LlRPdQuD8KFuSKMW35R41r85O
	 YABGefvY38QwQ==
Date: Tue, 3 Sep 2024 19:25:08 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 20/31] objtool: Add UD1 detection
Message-ID: <20240904022508.lcn36ouu5ka6eken@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <20e0e2662239a042a10196e8f240ce596b250ae8.1725334260.git.jpoimboe@kernel.org>
 <20240903081748.GN4723@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240903081748.GN4723@noisy.programming.kicks-ass.net>

On Tue, Sep 03, 2024 at 10:17:48AM +0200, Peter Zijlstra wrote:
> On Mon, Sep 02, 2024 at 09:00:03PM -0700, Josh Poimboeuf wrote:
> > A UD1 isn't a BUG and shouldn't be treated like one.
> > 
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  tools/objtool/arch/x86/decode.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
> > index 6b34b058a821..72d55dcd3d7f 100644
> > --- a/tools/objtool/arch/x86/decode.c
> > +++ b/tools/objtool/arch/x86/decode.c
> > @@ -528,11 +528,19 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
> >  			/* sysenter, sysret */
> >  			insn->type = INSN_CONTEXT_SWITCH;
> >  
> > -		} else if (op2 == 0x0b || op2 == 0xb9) {
> > +		} else if (op2 == 0x0b) {
> >  
> >  			/* ud2 */
> >  			insn->type = INSN_BUG;
> >  
> > +		} else if (op2 == 0xb9) {
> > +
> > +			/*
> > +			 * ud1 - only used for the static call trampoline to
> > +			 * stop speculation.  Basically used like an int3.
> > +			 */
> > +			insn->type = INSN_TRAP;
> > +
> >  		} else if (op2 == 0x0d || op2 == 0x1f) {
> >  
> >  			/* nopl/nopw */
> 
> We recently grew more UD1 usage...
> 
> ---
> commit 7424fc6b86c8980a87169e005f5cd4438d18efe6
> Author: Gatlin Newhouse <gatlin.newhouse@gmail.com>
> Date:   Wed Jul 24 00:01:55 2024 +0000

Interesting, thanks.  I'm having a senior moment as I can't remember why
this patch exists -- maybe it was code inspection?  My patch desciption
is awful.  I'll just drop it for now.

-- 
Josh


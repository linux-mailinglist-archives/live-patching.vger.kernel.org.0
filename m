Return-Path: <live-patching+bounces-410-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A5993C3F5
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 16:19:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFFBB1F21655
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 14:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FDC19D064;
	Thu, 25 Jul 2024 14:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="t3saHBug";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mberCuWn";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="t3saHBug";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mberCuWn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4448C224D2;
	Thu, 25 Jul 2024 14:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721917173; cv=none; b=aECOJjD7b2Hor4xlRLOiTtokDnu5aB6HRGrxCpnCvbl44BOWF11CuLRf0vdoZK57U9WiKbiy6fNpiv3NV3x+HzVGR5go5FPDJd6e45GPeP7enBWhPPECi3Nk3W734QiCbkIvEp2BYmpn73+mgb/3vKrvPGDMzTcW9gnvN9Qit8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721917173; c=relaxed/simple;
	bh=75/m0QKUv9Bq+3RwSXRk8U+MYmteiIveWdRpHtMxO3o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=HDyL0ox5j2FYZMfsjYjlLwfcR2S5orYa5TkjCYcFz2D4kKr3tMzr9u2K4XI+kgsIF/0TXkkaMaDjn3YLn86vUEwgRLH5+l+WKbevdExYMICGrqpMmO1q2dzbT6JUWY81fnzpqn5DgF2DOeWFcC+WAUWws1mg/P0L8lDAP9Y6V7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=t3saHBug; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mberCuWn; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=t3saHBug; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mberCuWn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6021321B38;
	Thu, 25 Jul 2024 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721917170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xH0N3Ol4QoRpdbqnTKuffcbj2K0Qcz8tjrE2rFdejCA=;
	b=t3saHBugl63CKJpqfIGzbksusZ/dimPFVhnlJg/dOi2qYspGGUUaY+/uiGskfRyeHa41w+
	TXJ9Q4aD26A34JQgjOgQ5Deod1KceSd0UcFiqU3I0CN0q+yXLX5M90SiT/YgX0UY5es3Iw
	qgWltWlVe2rMadJwVhOAkjAnLHwwgxg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721917170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xH0N3Ol4QoRpdbqnTKuffcbj2K0Qcz8tjrE2rFdejCA=;
	b=mberCuWn58eKrAVUuVf0pZJUxjCSrT7vLurMn49wX1lDx+FdSo78yKQeDh0c4p4D+YOldx
	Bnc0bsHAeIZR5ACg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721917170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xH0N3Ol4QoRpdbqnTKuffcbj2K0Qcz8tjrE2rFdejCA=;
	b=t3saHBugl63CKJpqfIGzbksusZ/dimPFVhnlJg/dOi2qYspGGUUaY+/uiGskfRyeHa41w+
	TXJ9Q4aD26A34JQgjOgQ5Deod1KceSd0UcFiqU3I0CN0q+yXLX5M90SiT/YgX0UY5es3Iw
	qgWltWlVe2rMadJwVhOAkjAnLHwwgxg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721917170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xH0N3Ol4QoRpdbqnTKuffcbj2K0Qcz8tjrE2rFdejCA=;
	b=mberCuWn58eKrAVUuVf0pZJUxjCSrT7vLurMn49wX1lDx+FdSo78yKQeDh0c4p4D+YOldx
	Bnc0bsHAeIZR5ACg==
Date: Thu, 25 Jul 2024 16:19:30 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
cc: Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
    Nicolai Stange <nstange@suse.de>, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [POC 0/7] livepatch: Make livepatch states, callbacks, and shadow
 variables work together
In-Reply-To: <20231110213317.g4wz3j3flj7u2qg2@treble>
Message-ID: <alpine.LSU.2.21.2407251618220.21729@pobox.suse.cz>
References: <20231110170428.6664-1-pmladek@suse.com> <20231110213317.g4wz3j3flj7u2qg2@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.10 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Flag: NO
X-Spam-Score: -4.10

On Fri, 10 Nov 2023, Josh Poimboeuf wrote:

> On Fri, Nov 10, 2023 at 06:04:21PM +0100, Petr Mladek wrote:
> > This POC is a material for the discussion "Simplify Livepatch Callbacks,
> > Shadow Variables, and States handling" at LPC 2013, see
> > https://lpc.events/event/17/contributions/1541/
> > 
> > It obsoletes the patchset adding the garbage collection of shadow
> > variables. This new solution is based on ideas from Nicolai Stange.
> > And it should also be in sync with Josh's ideas mentioned into
> > the thread about the garbage collection, see
> > https://lore.kernel.org/r/20230204235910.4j4ame5ntqogqi7m@treble
> 
> Nice!  I like how it brings the "features" together and makes them easy
> to use.  This looks like a vast improvement.
> 
> Was there a reason to change the naming?  I'm thinking
> 
>   setup / enable / disable / release
> 
> is less precise than
> 
>   pre_patch / post_patch / pre_unpatch / post_unpatch.
> 
> Also, I'm thinking "replaced" instead of "obsolete" would be more
> consistent with the existing terminology.
> 
> For example, in __klp_enable_patch():
> 
> 	ret = klp_setup_states(patch);
> 	if (ret)
> 		goto err;
> 
> 	if (patch->replace)
> 		klp_disable_obsolete_states(patch);
> 
> it's not immediately clear why "disable obsolete" would be the "replace"
> counterpart to "setup".
> 
> Similarly, in klp_complete_transition():
> 
> 	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
> 		klp_unpatch_replaced_patches(klp_transition_patch);
> 		klp_discard_nops(klp_transition_patch);
> 		klp_release_obsolete_states(klp_transition_patch);
> 	}
> 
> it's a little jarring to have "unpatch replaced" followed by "release
> obsolete".

I agree. I would also stick to the existing naming. It is clearer to me.

Miroslav


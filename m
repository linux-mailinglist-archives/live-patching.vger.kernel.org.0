Return-Path: <live-patching+bounces-615-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CAE96EB17
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 08:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2285EB23A40
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 06:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40531494A9;
	Fri,  6 Sep 2024 06:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g71Sg6Hy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Dn1ULSt/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g71Sg6Hy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Dn1ULSt/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046991411DE;
	Fri,  6 Sep 2024 06:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725605755; cv=none; b=pLSVFG4IEDhlYu791UUy1wDXvceIuVQ4lSwHsFEU1VzA68VdbH9BG1F6KM74dExA/Z6IMzd+Ffl/45Shy6uZS8KEpeIelbYUFgJmvpi/I0/VfjGPlLyRlfZzQ4gCIKKRXOzGflajLTpArqkJiw7T17K+wRqYDhz1xqJQ6gTDebU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725605755; c=relaxed/simple;
	bh=N2aqiFNRQUOVhhKlzSLKBeNsO8K5Nh4d2XRcM/+4SZk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MmSBps/K9d8rHy7UliL1z93i3lP8neqWfgJwJt2ShBESUXE5HLnT9SOEmAOZXOc/D6VevJ2sXSM6wBOgxOdSxGj9epCBVmmGqY4/G/7YBlj1v5DSIG5ZRsq6p4Onq/+JXjzgM+q8CWX/dP3fqZvax6P36TEa7TeBJZoW34DbVAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g71Sg6Hy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Dn1ULSt/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g71Sg6Hy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Dn1ULSt/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 133CC21AB3;
	Fri,  6 Sep 2024 06:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725605752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fTcgdnIMXOLSljxfwFwdmaeYM8dRsY9o8qtxU1XSl08=;
	b=g71Sg6Hy2hMnpKAH1IJjj0bqjxo212crlWc7bNQarI7sKrBAy++gGEOVHzx/z1H8rKYTEC
	Hy5hVRfuBBwWWVR5KOku5mDnk0IWR+o9YL04sp7HudJkImfyS2vuP1Mr2KdFMCXt9xeqaT
	bCyniGQuQVLJDHUYQbLiujg/opsSpV4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725605752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fTcgdnIMXOLSljxfwFwdmaeYM8dRsY9o8qtxU1XSl08=;
	b=Dn1ULSt/c+vCPxFwhPl4+fK/hWpgqs+cDaYCAwzHZn+943y/r6GgvV4EZhuQeYJX8QZZvc
	6wgsdye31A3MW/Bw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725605752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fTcgdnIMXOLSljxfwFwdmaeYM8dRsY9o8qtxU1XSl08=;
	b=g71Sg6Hy2hMnpKAH1IJjj0bqjxo212crlWc7bNQarI7sKrBAy++gGEOVHzx/z1H8rKYTEC
	Hy5hVRfuBBwWWVR5KOku5mDnk0IWR+o9YL04sp7HudJkImfyS2vuP1Mr2KdFMCXt9xeqaT
	bCyniGQuQVLJDHUYQbLiujg/opsSpV4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725605752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fTcgdnIMXOLSljxfwFwdmaeYM8dRsY9o8qtxU1XSl08=;
	b=Dn1ULSt/c+vCPxFwhPl4+fK/hWpgqs+cDaYCAwzHZn+943y/r6GgvV4EZhuQeYJX8QZZvc
	6wgsdye31A3MW/Bw==
Date: Fri, 6 Sep 2024 08:55:52 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
cc: Wardenjohn <zhangwarden@gmail.com>, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
In-Reply-To: <20240905163449.ly6gbpizooqwwvt6@treble>
Message-ID: <alpine.LSU.2.21.2409060851580.1385@pobox.suse.cz>
References: <20240828022350.71456-1-zhangwarden@gmail.com> <20240828022350.71456-3-zhangwarden@gmail.com> <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz> <20240905163449.ly6gbpizooqwwvt6@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,suse.com,redhat.com,vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

On Thu, 5 Sep 2024, Josh Poimboeuf wrote:

> On Thu, Sep 05, 2024 at 12:23:20PM +0200, Miroslav Benes wrote:
> > I am not a fan. Josh wrote most of my objections already so I will not 
> > repeat them. I understand that the attribute might be useful but the 
> > amount of code it adds to sensitive functions like 
> > klp_complete_transition() is no fun.
> > 
> > Would it be possible to just use klp_transition_patch and implement the 
> > logic just in using_show()?
> 
> Yes, containing the logic to the sysfs file sounds a lot better.
> 
> > I have not thought through it completely but 
> > klp_transition_patch is also an indicator that there is a transition going 
> > on. It is set to NULL only after all func->transition are false. So if you 
> > check that, you can assign -1 in using_show() immediately and then just 
> > look at the top of func_stack.
> 
> sysfs already has per-patch 'transition' and 'enabled' files so I don't
> like duplicating that information.
> 
> The only thing missing is the patch stack order.  How about a simple
> per-patch file which indicates that?
> 
>   /sys/kernel/livepatch/<patchA>/order => 1
>   /sys/kernel/livepatch/<patchB>/order => 2
> 
> The implementation should be trivial with the use of
> klp_for_each_patch() to count the patches.

Yes, it should work as well.

Wardenjohn, you should then get all the information that you need. Also, 
please test your patches with livepatch kselftests before a submission 
next time. New sysfs attributes need to be documented in 
Documentation/ABI/testing/sysfs-kernel-livepatch and there should be a new 
kselftest for them.

Thank you,
Miroslav


Return-Path: <live-patching+bounces-703-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C7A998D24D
	for <lists+live-patching@lfdr.de>; Wed,  2 Oct 2024 13:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CFF7284415
	for <lists+live-patching@lfdr.de>; Wed,  2 Oct 2024 11:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27FF1EC016;
	Wed,  2 Oct 2024 11:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KlvB0mvw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QkuHkfLF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HdGSysLS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fswr7Fpx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47605198A1A;
	Wed,  2 Oct 2024 11:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727869468; cv=none; b=mnpmFPzw9pahSAEDwiU4UyaWGu00GJfXhpffNbJgbAUZGfNCZwIfXEyd73enk29mpsPL9YyB0DPsnbi/EKIUL6C50B0TFPJC/tY++5y468pYCoBTfhfn+s+3HBHcC3akHGbh5v2h8mp7gVvoWzMuS6jd1KT8WQdvjhcHOpuuVFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727869468; c=relaxed/simple;
	bh=qHUj2chG45HP5pI6WQPZvWRFzZ85cTFWrCbDyJTc0Eo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iwptG21cabhdajF0aWSJr9BtWOtyvNtAgCaVcLsO18wGHGcvgBx0wdewEa0GdvlorEsnceiS/TasJfmvZaZqR7j5kHi7tbdwiXE1uIWnJELzTEGXOq06C0KQj6Uy2v47eGk91Eqqyc2phU48L/TKDbXDF3X/HPC1oZl4go/VIw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KlvB0mvw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QkuHkfLF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HdGSysLS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fswr7Fpx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 391F721A9A;
	Wed,  2 Oct 2024 11:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1727869465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4inqoHLTTBNG883UmwuIn7vlJLuklkt6YHwfxn6XIeo=;
	b=KlvB0mvw7rs5XfXT/uuUhdNcFCs9549pKXQx/okRaSVXCOfFhfz3WpnbYy1110sV36F5qS
	a6h2jCouHE+mCfHH+6l8+Xd5bILFs44pKYW+z4kaoHIUXEXzshQBC47AwFMYmuLHnFy8J1
	TWcqSDDPsUjXTAc3uwH4IMzVk3Z8Als=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1727869465;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4inqoHLTTBNG883UmwuIn7vlJLuklkt6YHwfxn6XIeo=;
	b=QkuHkfLFpT0+U9/ixwnvBdyZTd3YmSLC1/7edzw7S48SjnslMTCngmMHYY/ay5Ly4DlG5k
	aq3/7zXJlRdRlmBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1727869464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4inqoHLTTBNG883UmwuIn7vlJLuklkt6YHwfxn6XIeo=;
	b=HdGSysLSCXNNLQ17o4lw8kzOKE+x2aVoAcHa6Z7NJ7sLKE5ANxA7IkTx45kOzbsV6DRgva
	PveM9GGCviR+3/a3kNBMv7iX5wYEVb440a8AZxHDWT1Beb4QWCH2a+1zmoq8/ImdurIdYb
	jmO3JqRc6oMGrlnzQAZ/1+xG4am6DXY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1727869464;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4inqoHLTTBNG883UmwuIn7vlJLuklkt6YHwfxn6XIeo=;
	b=Fswr7Fpxu73JhWeicICW5Jc7KGOy6rVLMySFrBIdaEV+zz3ClA9NklMwVrTf1bpdmHwG6R
	jVg+9S4vaVpDtXAQ==
Date: Wed, 2 Oct 2024 13:44:24 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Wardenjohn <zhangwarden@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/1] livepatch: Add "stack_order" sysfs attribute
In-Reply-To: <20240929144335.40637-1-zhangwarden@gmail.com>
Message-ID: <alpine.LSU.2.21.2410021343570.19326@pobox.suse.cz>
References: <20240929144335.40637-1-zhangwarden@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -4.29
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	NEURAL_HAM_SHORT(-0.19)[-0.968];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pobox.suse.cz:mid,pobox.suse.cz:helo]
X-Spam-Flag: NO
X-Spam-Level: 

Hello,

On Sun, 29 Sep 2024, Wardenjohn wrote:

> As previous discussion, maintainers think that patch-level sysfs interface is the
> only acceptable way to maintain the information of the order that klp_patch is 
> applied to the system.
> 
> However, the previous patch introduce klp_ops into klp_func is a optimization 
> methods of the patch introducing 'using' feature to klp_func.
> 
> But now, we don't support 'using' feature to klp_func and make 'klp_ops' patch
> not necessary.
> 
> Therefore, this new version is only introduce the sysfs feature of klp_patch 
> 'stack_order'.

could you also include the selftests as discussed before, please?

Miroslav


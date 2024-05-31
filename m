Return-Path: <live-patching+bounces-304-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 27B0F8D6094
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 13:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A05151F2459C
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 11:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A196157492;
	Fri, 31 May 2024 11:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qmbr8yo0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Anhu6J0N";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qmbr8yo0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Anhu6J0N"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C3D15747E;
	Fri, 31 May 2024 11:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717154603; cv=none; b=F9av93fivBWrZ9Rgkf/wOsp/Y7OtMOj8kIJZp87V2N90XjuMfeSX0cMMnmeYOXBMUXitLeNrpO1Z6aEhXN9K4xlHGTq1fT5YhtVOPARSphTdP4W+tco/Y5FEu+8PWIy0ZzFowZgwWwVj3Qky2hDk1fq8pf98dhG488YNJWAlpcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717154603; c=relaxed/simple;
	bh=hFTTo4upWynDpVmGWm97HDuVGESaQYBs+I+iJ6ux5Ag=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gcpHUqAZHUbm5zzeD8VYsKXs/aTPYcxHbfAS6SBdba9kdPgsVVcni2oXNxYzkq4xkHJ3Fs5sLUJyQJEoHWQY7NlKH0EyZj28OcXHZO+GWVWG2gsjCdzgAI9kVRHKBDx2n6ZQ7a8ttxKDRyX50itL3WGxnifQGKOFY9lgOI4bUoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qmbr8yo0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Anhu6J0N; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qmbr8yo0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Anhu6J0N; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D2E7C21B8A;
	Fri, 31 May 2024 11:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717154598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6MKGKYsRXHwrNrAl3lmaoTrrWO0EY8d++5MCut8e92c=;
	b=qmbr8yo0Gq+BW0dE0XgxZnBveXjcbXuC/33fhYxYTSInVa3QazRXnQ4pOBTktKkBEYSgmK
	CEHTG1mlrxvLuGLkcjD2oG3u4CV48nP0EzWr0poqucR+dOtn0LrZQ6eaatX0Q9qZW3uHEn
	F2+XEcrOHNa/jlSqoOcRCJAIRzRu0SA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717154598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6MKGKYsRXHwrNrAl3lmaoTrrWO0EY8d++5MCut8e92c=;
	b=Anhu6J0Ns+2+NuIR8OjzqS6TAb1VZ7tSxPSgrPH0f0oy06aG2WJvhpZfSCdlGov9lfRXix
	Tyc6VMhFiWmQ3KCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717154598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6MKGKYsRXHwrNrAl3lmaoTrrWO0EY8d++5MCut8e92c=;
	b=qmbr8yo0Gq+BW0dE0XgxZnBveXjcbXuC/33fhYxYTSInVa3QazRXnQ4pOBTktKkBEYSgmK
	CEHTG1mlrxvLuGLkcjD2oG3u4CV48nP0EzWr0poqucR+dOtn0LrZQ6eaatX0Q9qZW3uHEn
	F2+XEcrOHNa/jlSqoOcRCJAIRzRu0SA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717154598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6MKGKYsRXHwrNrAl3lmaoTrrWO0EY8d++5MCut8e92c=;
	b=Anhu6J0Ns+2+NuIR8OjzqS6TAb1VZ7tSxPSgrPH0f0oy06aG2WJvhpZfSCdlGov9lfRXix
	Tyc6VMhFiWmQ3KCA==
Date: Fri, 31 May 2024 13:23:18 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Joe Lawrence <joe.lawrence@redhat.com>
cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] livepatch: Add compiler optimization
 disclaimer/docs
In-Reply-To: <20200721161407.26806-1-joe.lawrence@redhat.com>
Message-ID: <alpine.LSU.2.21.2405311319090.8344@pobox.suse.cz>
References: <20200721161407.26806-1-joe.lawrence@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.980];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[3]

Hi,

On Tue, 21 Jul 2020, Joe Lawrence wrote:

> In light of [PATCH] Revert "kbuild: use -flive-patching when
> CONFIG_LIVEPATCH is enabled" [1], we should add some loud disclaimers
> and explanation of the impact compiler optimizations have on
> livepatching.
> 
> The first commit provides detailed explanations and examples.  The list
> was taken mostly from Miroslav's LPC talk a few years back.  This is a
> bit rough, so corrections and additional suggestions welcome.  Expanding
> upon the source-based patching approach would be helpful, too.
> 
> The second commit adds a small README.rst file in the livepatch samples
> directory pointing the reader to the doc introduced in the first commit.
> 
> I didn't touch the livepatch kselftests yet as I'm still unsure about
> how to best account for IPA here.  We could add the same README.rst
> disclaimer here, too, but perhaps we have a chance to do something more.
> Possibilities range from checking for renamed functions as part of their
> build, or the selftest scripts, or even adding something to the kernel
> API.  I think we'll have a better idea after reviewing the compiler
> considerations doc.

thanks to Marcos for resurrecting this.

Joe, do you have an updated version by any chance? Some things have 
changed since July 2020 so it calls for a new review. If there was an 
improved version, it would be easier. If not, no problem at all.

Miroslav


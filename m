Return-Path: <live-patching+bounces-331-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F262B8FFDBC
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 10:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ACB1283762
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 08:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB42E15A879;
	Fri,  7 Jun 2024 08:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fVVQYJv8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ML1xiPMp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fVVQYJv8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ML1xiPMp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDBA15AAC8;
	Fri,  7 Jun 2024 08:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717747271; cv=none; b=ndjiLwsVPk4yXU7UxkdEi6xuIi6VsoxuFwttiRzJ4wSIJyq9MIKoPg5mmBJdMiYtGHwcTUnm3noKJN/c3c6P0888IB1AoMA1W/1A50L7I9b65X5qNlruy0f4mCegPzJtOiQiKlTE4UFbeCs/Z7tLwH/isfL1+lZU5hByqcXgO4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717747271; c=relaxed/simple;
	bh=5Mi/7plwqdDd5Oei9118sD4entkbXks9AUfifHbB7g8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Khmpn3FhdIXpHqmH5/dZ4TY1VbN4tZDOoBHnVTXHEWsdobFDFMMi0GaHEAaizwviFku0HPAXxM167qIPHZMdNd3LXKjGbYkNGRYksEPtyimRa80kNz0s8mSugg3dvLSgWpSJZO8AKGtuZ6uzNYifS9kOCF6N7wkQSq/g7wv/9SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fVVQYJv8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ML1xiPMp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fVVQYJv8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ML1xiPMp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0FF3A21B4D;
	Fri,  7 Jun 2024 08:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717747268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QrS1YTupYUqFB+6ocpJF2ZlaZZl5/f78K8n0nIv17hg=;
	b=fVVQYJv8RpG5Qbw8R1JdsJtqImclCSJeg4XyRWUPX6iI8xDuJ7S2QGQbCYm3jmXbPken08
	XL3padugHEdgqnVClxCYeeROVGJ8FDaUQT7/FVy3Uxo9u2+GFyVfSnyj6gk5ruuXzSWZi7
	h2wlXc6lyS1i67q7ElHp/MiFodsY1Lc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717747268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QrS1YTupYUqFB+6ocpJF2ZlaZZl5/f78K8n0nIv17hg=;
	b=ML1xiPMp9+6pFJg90cDJs0gk7jlcPR1kxr8b54KAaJhvlucbe6mj4hBApux5JSAKk/+rQ2
	6tcfN/C1/iWWlhCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717747268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QrS1YTupYUqFB+6ocpJF2ZlaZZl5/f78K8n0nIv17hg=;
	b=fVVQYJv8RpG5Qbw8R1JdsJtqImclCSJeg4XyRWUPX6iI8xDuJ7S2QGQbCYm3jmXbPken08
	XL3padugHEdgqnVClxCYeeROVGJ8FDaUQT7/FVy3Uxo9u2+GFyVfSnyj6gk5ruuXzSWZi7
	h2wlXc6lyS1i67q7ElHp/MiFodsY1Lc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717747268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QrS1YTupYUqFB+6ocpJF2ZlaZZl5/f78K8n0nIv17hg=;
	b=ML1xiPMp9+6pFJg90cDJs0gk7jlcPR1kxr8b54KAaJhvlucbe6mj4hBApux5JSAKk/+rQ2
	6tcfN/C1/iWWlhCA==
Date: Fri, 7 Jun 2024 10:01:07 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Joe Lawrence <joe.lawrence@redhat.com>
cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] livepatch: Add compiler optimization
 disclaimer/docs
In-Reply-To: <a93e9121-4558-0cb7-224b-550738e45641@redhat.com>
Message-ID: <alpine.LSU.2.21.2406070959290.29080@pobox.suse.cz>
References: <20200721161407.26806-1-joe.lawrence@redhat.com> <alpine.LSU.2.21.2405311319090.8344@pobox.suse.cz> <a93e9121-4558-0cb7-224b-550738e45641@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.991];
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
X-Spam-Score: -4.30
X-Spam-Flag: NO

Hi,

On Fri, 31 May 2024, Joe Lawrence wrote:

> On 5/31/24 07:23, Miroslav Benes wrote:
> > Hi,
> > 
> > On Tue, 21 Jul 2020, Joe Lawrence wrote:
> > 
> >> In light of [PATCH] Revert "kbuild: use -flive-patching when
> >> CONFIG_LIVEPATCH is enabled" [1], we should add some loud disclaimers
> >> and explanation of the impact compiler optimizations have on
> >> livepatching.
> >>
> >> The first commit provides detailed explanations and examples.  The list
> >> was taken mostly from Miroslav's LPC talk a few years back.  This is a
> >> bit rough, so corrections and additional suggestions welcome.  Expanding
> >> upon the source-based patching approach would be helpful, too.
> >>
> >> The second commit adds a small README.rst file in the livepatch samples
> >> directory pointing the reader to the doc introduced in the first commit.
> >>
> >> I didn't touch the livepatch kselftests yet as I'm still unsure about
> >> how to best account for IPA here.  We could add the same README.rst
> >> disclaimer here, too, but perhaps we have a chance to do something more.
> >> Possibilities range from checking for renamed functions as part of their
> >> build, or the selftest scripts, or even adding something to the kernel
> >> API.  I think we'll have a better idea after reviewing the compiler
> >> considerations doc.
> > 
> > thanks to Marcos for resurrecting this.
> > 
> > Joe, do you have an updated version by any chance? Some things have 
> > changed since July 2020 so it calls for a new review. If there was an 
> > improved version, it would be easier. If not, no problem at all.
> > 
> 
> Yea, it's been a little while :) I don't have any newer version than
> this one.  I can rebase,  apply all of the v1 suggestions, and see where
> it stands.  LMK if you can think of any specifics that could be added.

I will walk through the patches first to see if there is something which 
can/should be changed given the development since then.

> For example, CONFIG_KERNEL_IBT will be driving some changes soon,
> whether it be klp-convert for source-based patches or vmlinux.o binary
> comparison for kpatch-build.

True.

> I can push a v2 with a few changes, but IIRC, last time we reviewed
> this, it kinda begged the question of how someone is creating the
> livepatch in the first place.  As long as we're fine holding that
> thought for a while longer, this doc may still be useful by itself.

If I remember correctly, the conclusion was that this doc was beneficial 
on its own.

Miroslav


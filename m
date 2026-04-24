Return-Path: <live-patching+bounces-2544-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uDmqE6Pq62nhSwAAu9opvQ
	(envelope-from <live-patching+bounces-2544-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:11:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A3069463BBF
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 04BDF302AE25
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB2B3E4C7E;
	Fri, 24 Apr 2026 22:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BAjm7lCX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBAB388E62
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777068632; cv=none; b=gTOUbuAS8aELm+GFaKcyhSwlt5xs8FNC2q8+AdtGMnLl89JXlEF/1h65aguPh0wm3fnCD6876BilQytEFTKQxaKJflzVHrpBy4MOY31jIhi7EaAMl0Xb0SQiaDR8sY69HUMZ91PHMdyeVyVOseaemD+pvZBU69wfAB6pZxUmfJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777068632; c=relaxed/simple;
	bh=GNjPa0QzvhI0mOqKG1vhNikbHzECCewsJEI3GHGfdkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q6JU144o3/T7+LdY0ctIdJJleh261eDI9wcVBzHRw6qvRqoI/+4jj1nUhOc8RF/4IWwxYGZnoPJxhVLhvAYqfRr3pALGYuhOe/5+2LfHsbxmtCWjcxLng8zva7HgWFpMkraAhhkV8b5zDh+f86xomxC5+rsbAErn8qZeJ7la/Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BAjm7lCX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582FAC2BCB0
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777068632;
	bh=GNjPa0QzvhI0mOqKG1vhNikbHzECCewsJEI3GHGfdkk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BAjm7lCX2GB5vBeJIj2v+hXsSyQ63xEqqhQ3gMeZg8zd+CvMBqXMFdgNcp2XXgRBi
	 5vuG7Xja9CdLgxeC8C4Qd0MRdpgWnO6C3CBwc9HA3cy+4dAWWiH5+d02F1wNglWqYg
	 n/yJqjue5yP4EfoYgFYCcPLiOmxoHhNJF+zXUVdgzvTXFMqeF27d7aoFMZmusj9J1y
	 URPCNN/bueXvjFWn+O+L37TFv6Hu83/ucQnWLungW/pU9iq/PUy3Ef6fLehPDUDI8n
	 VjQD+wQbS6c2g9CX75Tg7S61ZUYpiHtoBxh/lEmYUGvWcm9Ghyeiy0DsuC9M1wIc76
	 Lqm0TLYP6ApRQ==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a049a767c3so94765676d6.1
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 15:10:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9wFdpxfxKn1a82XsLFFdsbkcLH1hmYz/HBW3bEJNn5XFRZYcrgH1ht2k9zSHI7i9A3gkBcGFlc0uI9rLzu@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf2lu8FUpbt8anQREUZf5ouJt7yqzfSxY0pY+fuy1+32UVObm3
	cs4HvPKVoCTarEgF98VT1ioYPH0FPgNutCBFeLVQQ/OEWez5207/uXQtBy2Xqn2SD8xrTUP1RjZ
	9lKg1MA+4BY4lxcc+tfmJw5QztEatxWI=
X-Received: by 2002:a05:6214:5b86:b0:89c:cfa9:f1fe with SMTP id
 6a1803df08f44-8b028324ee8mr459687226d6.2.1777068631604; Fri, 24 Apr 2026
 15:10:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <360097539ed947aea82ce5392548a898a346ffa7.1776916871.git.jpoimboe@kernel.org>
 <20260423083500.GU3126523@noisy.programming.kicks-ass.net>
In-Reply-To: <20260423083500.GU3126523@noisy.programming.kicks-ass.net>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 15:10:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Kjtpu6C4Wi30Mk+AD--zOJebz0Xm5_9HaXcA=Ek0WoA@mail.gmail.com>
X-Gm-Features: AQROBzCh6Om-B2z6RfzOl3MIN03BB6A3LcWT_znez_zz1FgA7cmaUIz-im_T33o
Message-ID: <CAPhsuW7Kjtpu6C4Wi30Mk+AD--zOJebz0Xm5_9HaXcA=Ek0WoA@mail.gmail.com>
Subject: Re: [PATCH 31/48] objtool: Add is_alias_sym() helper
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A3069463BBF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2544-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Thu, Apr 23, 2026 at 1:35=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Wed, Apr 22, 2026 at 09:03:59PM -0700, Josh Poimboeuf wrote:
> > Improve readability with a new is_alias_sym() helper.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Acked-by: Song Liu <song@kernel.org>


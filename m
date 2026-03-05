Return-Path: <live-patching+bounces-2133-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PaONunkqWl1HAEAu9opvQ
	(envelope-from <live-patching+bounces-2133-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 21:17:45 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E34EE21815A
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 21:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0B3703026074
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 20:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B63B37D10E;
	Thu,  5 Mar 2026 20:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EbPLoeaW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3C72E173B
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772741427; cv=none; b=GeHMscZC3gd++BTm8EMHkso1KSJYZWOe9WchuI3rSx0iFdoqGTUn23cxT9PnzCAC9iMSuupQVQRhAsHrQ9yZDImJprNdTA7sytSkbAh4Lue9eyBq2mFbYfKKRpgELy4bj0T+FZOfbXhkT2xbdOoH/OseeZuk1RvXR1knelj5i38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772741427; c=relaxed/simple;
	bh=RTePKOBGP4Yp87aa7PYI9xw7JI52xiMqyJx0apK6izE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gxxgti1FfILuguJhUzTW45mb0pY0hfeW+G+sO8pzOtC6pQ8Mf3NuYP/34Pa8APija83454eYMhIVYxHJsIsMzCBt43g6Q4nqm5O0VNZUxL9ogfaXnEqK4aOCQQzAAax2iBfb96QbsAB12jiUGgvOg5rsJMwyjfdtXCFYExVIdos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EbPLoeaW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0231C116C6;
	Thu,  5 Mar 2026 20:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772741427;
	bh=RTePKOBGP4Yp87aa7PYI9xw7JI52xiMqyJx0apK6izE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EbPLoeaWKr7CMMlrNp3qqRA3dyUWfBzK31fKKF0zxBo7aAOrLN1FMYTNAYwnpLylC
	 lj+XesJXsEItPi1vBumEMHustlItlDkXroJuxbTbONRgdPNzVTc9PolcE5Z4Bub3B1
	 hTKgaCuUCwmLUMNOy57Y0vLcrb45SuOL60ioic3rpbyTyR4EVulkb/lqVdpEWlzKIt
	 a13ks5OA645r2j6vwfwTHJx6isWc14G8HqCycM3JFlYj2rcq68CNnIqVVxV1JbjKC2
	 a4urSNzDSfQfHS1rhG9uAMU341yKO+7gPTA1exNpeAwhjKLT+OHkmDXTGEIDiQ9CxU
	 CcXz3IXOuSwig==
Date: Thu, 5 Mar 2026 12:10:25 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 13/13] livepatch/klp-build: don't look for changed
 objects in tools/
Message-ID: <kjhjrmhy5ajrot2fx42svqeyagxm6yu5glsrct2fm327aiajlc@npi4dbfbgew3>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-14-joe.lawrence@redhat.com>
 <os3ykxdsfe6bz2b2pd5x5wb76ya5ecogbvjgkcophf55wchv7r@vdp2dzrzrdny>
 <aaZHv6YoJzwmZF6m@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaZHv6YoJzwmZF6m@redhat.com>
X-Rspamd-Queue-Id: E34EE21815A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2133-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 09:30:23PM -0500, Joe Lawrence wrote:
> On Mon, Feb 23, 2026 at 01:41:58PM -0800, Josh Poimboeuf wrote:
> > On Tue, Feb 17, 2026 at 11:06:44AM -0500, Joe Lawrence wrote:
> > > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > > ---
> > >  scripts/livepatch/klp-build | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Why?
> > 
> 
> I don't have a pithy repro captured here, so I can just drop this for
> now.  I was playing with building klp-build selftest modules and
> stashing the resulting .ko's under tools/testing/selftests.
> Occasionally subsequent klp-builds would get confused when seeing only a
> .ko and complaint about missing ancestor object files.  Which led me to
> ask, why does it look in directories that don't even include kernel
> build artifacts.

Yeah, I don't necessarily object to the change, but it would be nice to
have some kind of justification in the commit log.

-- 
Josh


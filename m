Return-Path: <live-patching+bounces-1950-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNZHDu43fWlMQwIAu9opvQ
	(envelope-from <live-patching+bounces-1950-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 23:59:58 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5772EBF43A
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 23:59:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 02EA6300B299
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 22:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0036F35B654;
	Fri, 30 Jan 2026 22:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gl6LrMwn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A5835B627
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 22:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769813993; cv=none; b=lFtPaA8bfdkbQddz64y468FVYuv8xIi9T1KVbsKKqIEsIpqqH6z6oRMOBSCPICrQs9/8ti8WfpBf6XSV2a+V/5ucMHYnMS3OM88LDz7GyqznKPA8F6kTRUpH0ov5cflS1siKIUf8agbWByfwx0+3ZqbID2NN7D7+3+DFcMoktL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769813993; c=relaxed/simple;
	bh=W7G66Feyh2f5ZAh1TnRZ246KzGuxP+X8YBy/BpRxPgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sK6k4KusjWxtw/rsS63l9BX/zegJXPWu5oRxh/dxJdW0J0pDGUvo6zHBMhGdrkfAB641txybeddOcD/mp9acIC0LjsytbTegrNwV/7RroxxaU46N73n8A1tjOOLKcSE4khGmog53/Y9THoUK70L/AwD6AuB48YeI7O+Jantbe3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gl6LrMwn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CC9C4CEF7;
	Fri, 30 Jan 2026 22:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769813993;
	bh=W7G66Feyh2f5ZAh1TnRZ246KzGuxP+X8YBy/BpRxPgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gl6LrMwnotq4MHyVnBH9S5K2l2i9Qb4Q5h7ZyEEA4K9u/JHCdYbezXXysLRxtdy+f
	 CFkvvj4f3KGBBxdwSsM3PsQb/MGh3JAmzm8A2/s4kQ800on+oroG7+x/8FMZMR7ugw
	 bc/jnWuR5GXxjVyeDVzxIBgduJ6ZVMYwb6s4+plB6biPKYijV8HMowH1M2hHZ+mRke
	 Grt3befvtRS/lUnplnzzp7vpQbJmnNVtRfGopZbWKutQW5v6yRt1WuPXtvqk4FxLt0
	 Rfsh/ilpdFKslBsqnIjJ0uq+xfm7jVCk0frG3zG/4aPruq8m+t3Jj8ry0KJ2WT+3y5
	 0QG608sj3946A==
Date: Fri, 30 Jan 2026 14:59:51 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 3/5] objtool/klp: validate patches with git apply
 --recount
Message-ID: <omt3bm5upud3sywupr3g3evxqs437x5f5wcxlnba2j5u4rtle2@b62zb4hfydby>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-4-joe.lawrence@redhat.com>
 <lqchka76tcwjxitn5tm42keexglnac6iveb44ppgx4c425qsfg@sbcdkfgmebqu>
 <aX0W0JWRkLbuQpGY@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aX0W0JWRkLbuQpGY@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1950-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5772EBF43A
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 03:38:40PM -0500, Joe Lawrence wrote:
> On Fri, Jan 30, 2026 at 12:05:35PM -0800, Josh Poimboeuf wrote:
> > Hm, isn't the whole point of --recount that it ignores the line numbers?
> > Or does it just ignore the numbers after the commas (the counts)?
> > 
> 
> I don't know exactly.  As I continue digging into the test that sent me
> down this path, I just found that `git apply --recount` doesn't like
> some output generated by `combinediff -q --combine` even with NO line
> drift... then if I manually added in corresponding diff command lines
> (to make it look more like a .patch file generated by `diff -Nu`), ie:
> 
>   diff -Nu src.orig/fs/proc/array.c src/fs/proc/array.c     <---
>   --- src.orig/fs/proc/array.c
>   +++ src/fs/proc/array.c
> 
> Suddenly `git apply --recount` is happy with the patch.
> 
> So I suspect that I started with git not liking the hunks generated by
> combinediff and drove it to the rebase feature, which solves a more
> interesting problem, but by side effect smoothed over this format
> issue when it recreated the patch with git.
> 
> Anyway, I think this patch still stands on it's own: perform the same
> apply/revert check as what would happen in the fixup steps to fail
> faster for the user?

If we just run fix_patches() at the beginning then can we just get rid
of validate_patches() altogether?

-- 
Josh


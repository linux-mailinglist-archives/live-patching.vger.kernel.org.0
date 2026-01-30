Return-Path: <live-patching+bounces-1941-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WNdtJQUQfWmMQAIAu9opvQ
	(envelope-from <live-patching+bounces-1941-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:09:41 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E869BE4FC
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 026E43025C41
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573A131328E;
	Fri, 30 Jan 2026 20:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clnriwho"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324BB311964
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769803778; cv=none; b=EO0d+9yixLcBX/WcEqtQWc4xOJypwtZTJIEdMEgl7Q73WPOYzOXyDHpEsqqn7nS6C6KFhmlkDz6winqZ1yXfzVZhkSTiItCWz+uFCOw3W65wG33H1gNqrhFxU6CUm5ZRVQEBijafhtcgORysbgARbU6G4J71NBxP3i5LOXc6EZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769803778; c=relaxed/simple;
	bh=laDDcedekiuyorAM7msZ5Y67n/K9jtFg4IB0Mc9qFZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbSx8B72Bwybgn6j30zyVW69m7cS70vVJMjsvCwwYlXPkedA1HC4jyGNBByJZUKjbOtbi1QSOIB4F3yCX3tPvRqqYP0vr5Vxa284y31Tpcl5v98D9GrBbEriTkinnXfwcamRCH/xeJWU9cTG4WZf6R95a3W+yLCbFYJSnU7mqB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clnriwho; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32339C4CEF7;
	Fri, 30 Jan 2026 20:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769803777;
	bh=laDDcedekiuyorAM7msZ5Y67n/K9jtFg4IB0Mc9qFZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=clnriwhoDwWogKG8xjEZQryJIXob3Yx8seU5ZYiWsSypsd9yDZdtqYU7VttcjlQIj
	 ZM1QqjqH4WSMN1pBpl1KYmzLeuIlhwsqVHTcLOiInJG6sc2jR+N2qz45/dX5H/Elci
	 liMsz0ym1ct8/GgORAWTuDbchZLqhEOPrKPC5KsczIALeKiOY1xMNcB8vsu0ruD7z5
	 SBw/HXRSyVYPZuoNe0wNg9atj2BEI7fQtmnOTacjH3QBwJocVS/1FK1JvBfvmb5wxu
	 gM3TsD/o0du9OUZ0B+xf6dKHDoRSEFdmzlMiAbDlllVYXF9DntDJCYg6rR60BVQoLC
	 d549cQ71nZTuQ==
Date: Fri, 30 Jan 2026 12:09:35 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
Message-ID: <fayrtgx5l5wvcwkuxqc4it3t4ft3o7rbn4uojtmzjxq66nniw7@v6om4zyepshh>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-5-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260130175950.1056961-5-joe.lawrence@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1941-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1E869BE4FC
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 12:59:49PM -0500, Joe Lawrence wrote:
> @@ -131,6 +133,7 @@ Advanced Options:
>  				   3|diff	Diff objects
>  				   4|kmod	Build patch module
>     -T, --keep-tmp		Preserve tmp dir on exit
> +   -z, --fuzz[=NUM]		Rebase patches using fuzzy matching [default: 2]

Ideally I think klp-build should accept a patch level fuzz of 2 by
default.  If we just made that the default then maybe we don't need this
option?

-- 
Josh


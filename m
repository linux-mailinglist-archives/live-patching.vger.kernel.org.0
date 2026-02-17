Return-Path: <live-patching+bounces-2038-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPhoEWK0lGlbGgIAu9opvQ
	(envelope-from <live-patching+bounces-2038-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 19:33:06 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A9D14F2BF
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 19:33:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05A49300AB1C
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 18:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74FB0372B2D;
	Tue, 17 Feb 2026 18:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B3Atq47X"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AAC36D518
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 18:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771353181; cv=none; b=hrif5d54co6DCBGK6AGQhJJ2/+cZjHiy82lHDYNaR5jMEdwU1MCV5oUSX155ev7EPxA/qfwgodbjfHO1DJlBfWyB2Zv/hGvGm5swhH+Hw++p/DsnvGMibm18s17upskUu+lcGjWI4lD8+/PZ3YPAmakdOLTBi5WkQvloJl7YiSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771353181; c=relaxed/simple;
	bh=q7cYtuKnfN9MKVJsQe2n4HMm3Kpnca5l6mbsPxIQFQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hath7zhOxiYf1PG9wa1rWnaA+9tDPDLiPip5L/zF6oLZLIOC66MbTu2ytNcsORWsnuCnvURlqnoBFmoOT3gGRmO13XV9KBOqZA1Pz1SJ7tMPEN8Zjz12nKPFi7CdjQ/SSKFhE1wnGjr2xI9GGenx7pz7xMZWXNSIaVFBKWnP9sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B3Atq47X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B5CC2BC86
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 18:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771353181;
	bh=q7cYtuKnfN9MKVJsQe2n4HMm3Kpnca5l6mbsPxIQFQ4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=B3Atq47XF9tkGoGkyDb1pcH2OcSQjIyb0mflOHVVEfJlBO1uFwdMmFe5MR1Q6WGPq
	 1aD2iish7tX8X5gGI1gZ2lZRmYTwby8zqACUkRMaaFEaQ85OUeYzvnS+pX6+jAzuv1
	 EKmd+F9RMBwkhIQzTCERUQHpJhypWU1/r2eqKy1UVx3HWIouy9BETvBuqLLa+pZONL
	 icdqskRWZkMmk3B8INRQlhuaBQaaOFg8nbv7G4JCbut87UYVpL2AJVYsMLkKtz154F
	 3+T2UI0PouY1f1UtaZTmsEtt10fAsfHignMGznq8qfrtBDSid/ZZBoVIisUdgEUOAP
	 GqeY18RUNGx7g==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89549b2f538so11336d6.2
        for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 10:33:01 -0800 (PST)
X-Gm-Message-State: AOJu0YwA9JgBxzvTql99wibNT51ZOj9Z/R0f5l8zIbTvaK+dkCNRI7so
	jr/g4wYbsHkvTzn4oZRZcG8wgR4WMYeqF/4mNbi6jaLHPfq8Kaj2yOwhoVtFSX/jb9/MD6M3UL8
	c2ZN2HkQBcyJRsECHSPIBl302cPpJYns=
X-Received: by 2002:a05:6214:1d08:b0:896:fea0:cd01 with SMTP id
 6a1803df08f44-89740468574mr164804886d6.34.1771353180272; Tue, 17 Feb 2026
 10:33:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217160645.3434685-1-joe.lawrence@redhat.com> <20260217160645.3434685-11-joe.lawrence@redhat.com>
In-Reply-To: <20260217160645.3434685-11-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 17 Feb 2026 10:32:48 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4Qe0sqePzFn7ZAURyreNrMkuKO_e-nkckWis2N0jN8cg@mail.gmail.com>
X-Gm-Features: AaiRm504bXUTfJVXFu0kt41PkfTWlwLRPTqBhjBpssYpxhDD_F2lmVuj7kXaO8I
Message-ID: <CAPhsuW4Qe0sqePzFn7ZAURyreNrMkuKO_e-nkckWis2N0jN8cg@mail.gmail.com>
Subject: Re: [PATCH v3 10/13] livepatch/klp-build: provide friendlier error messages
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2038-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 92A9D14F2BF
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 8:07=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> Provide more context for common klp-build failure modes.  Clarify which
> user-provided patch is unsupported or failed to apply, and explicitly
> identify which kernel build (original or patched) failed.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

Acked-by: Song Liu <song@kernel.org>


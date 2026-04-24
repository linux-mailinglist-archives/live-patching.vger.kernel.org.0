Return-Path: <live-patching+bounces-2540-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOaxBZbo62nNSgAAu9opvQ
	(envelope-from <live-patching+bounces-2540-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:03:02 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C1B7463A91
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A51D930166E7
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01ABB34887E;
	Fri, 24 Apr 2026 22:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WECD6KrT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D331B3043CF
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777068157; cv=none; b=nD2+d6+ymOeh6bNgLVvS7Hup3u703TtcUjJ2m3safFQPXCGv/ucWm4mnQHzA0TNrDg57uoVTXWwGFGIP58hSrp/f0IUtz6E6xsQi5hYtYZZhNoHL3zY5F4Eve1w6RYBF44st7FYmS1ubDdEpbtoWYa0z5J0gz46fWLJDdY8/WCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777068157; c=relaxed/simple;
	bh=hXWA/aGL9paxVioayE2tyloPwLnP1YuFvrd1C3ASfkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DMWqNK3fs+8mclnuaNtTIi8JFn7SZqJDBWDNnZL9v9YMYCk4pqp6INFcVD4aJMItJdEDeKrqlg1kYk0SxBgwhovFOt4L6Sd+w1sC9HtvDHH7o4SgH5NK9Sp5yggPiUDzRmiwsbcBAIxEGKbl7YTq9VQc4ZXNxX6ZLkG+hpVg0o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WECD6KrT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96496C2BCB8
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777068157;
	bh=hXWA/aGL9paxVioayE2tyloPwLnP1YuFvrd1C3ASfkY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WECD6KrTwsKH4+41wDnIm57HBzQPBtMbR+tULAS3FElgrKVWBZowHpTq5dJg2KiLa
	 6qQQdtCeakbZqKKlfFbOATiOBW+m1d+746wb0aAfr4ek37Tq55r2P42TGTfbqFBF77
	 jwdDcHOO94dHXEOnaVDzWkRvwGAIocLhY9QR1wbvvbXoZLLaXg4Gg1DmFPKUXBJfJm
	 U/c03kieDgdFMqEXBFC+XcOHrVUZZemkFOHiR4OQgltudiIpKdhv5d8cCJxSj+NM6t
	 CF1MoJyAiZasZ2BEaQlY/FefbQpG+zhrpu9brL+RkcBT0qw5ML9F9m7v5I57HqY1+z
	 a9WBaBtWTp3xQ==
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-60fd9b71745so2935619137.1
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 15:02:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+5ZOs1VQxpS+fo6A+C0iTXvyCYeMUcrcYCHo2tTXiDLk5K1akekpyvqbIFlT2R1nav622LUNSfPXg+4/d/@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5GkEtn13ZtpmKiByb3BGwLtrYpYRxEwNfJyob7AKG8YYKj37J
	+bZvk31OeugCKNL3aUcaK3zb+03SnwL3ucEIPVrv2kNlYf9meq+XsleUBPA2iGk4PVivmzV8l3b
	9J5QRu5QI5F3ON9DjYXJkUEbINX6hoE4=
X-Received: by 2002:a05:6102:4bc8:b0:60c:bca6:8194 with SMTP id
 ada2fe7eead31-616f4741f1amr16970922137.2.1777068156650; Fri, 24 Apr 2026
 15:02:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <bf64851de287f98a2a94900df0dad7edf3d694c0.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <bf64851de287f98a2a94900df0dad7edf3d694c0.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 15:02:24 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Gwv-QsGmYavprzvkRtMd5RQUr3pJH+5WE=S_SWNiUgw@mail.gmail.com>
X-Gm-Features: AQROBzAx06upHApmshMaCSANuTlcr51rLOYwYdzMd_FZGZwYdG-2kktkhEnA3cs
Message-ID: <CAPhsuW7Gwv-QsGmYavprzvkRtMd5RQUr3pJH+5WE=S_SWNiUgw@mail.gmail.com>
Subject: Re: [PATCH 29/48] klp-build: Print "objtool klp diff" command in
 verbose mode
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5C1B7463A91
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
	TAGGED_FROM(0.00)[bounces-2540-lists,live-patching=lfdr.de];
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

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Print the full objtool command line when '--verbose' is given to help
> with debugging.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>


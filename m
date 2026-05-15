Return-Path: <live-patching+bounces-2834-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iPrcCcaPB2rB8AIAu9opvQ
	(envelope-from <live-patching+bounces-2834-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 23:27:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8101E55814B
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 23:27:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49E6F3076F32
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 21:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFAB73ED13B;
	Fri, 15 May 2026 21:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxqPmvQ3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFBE3ED110
	for <live-patching@vger.kernel.org>; Fri, 15 May 2026 21:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879799; cv=none; b=n6Jm5iAcdpUQb4xrQoq4oMz6wk9EfxRrlig88Qq2BKFl00MTgDBK+ABjSKFz5j4++ZPHo7onJ2QGFLndqPWRfAOKWKRC37tdmI0Cs6FHw4H0YVXHNr71MI77qDJpU4bpFe5nVNXg3OIpHSu1XQugbNh0nUAE5B+XxHrKIXcEapI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879799; c=relaxed/simple;
	bh=7qgjgFxUvKpGr/7MrBVaKHvp/HakTh8FDvf1KsdtDJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QzKdldc+QvLw3lYi+BPZr49xbnFdmK/XTyWoc4W/g0bVwMBxmvgzbpBs7Sw5lWfZSHUWu7/wB8TQ6a1/HsA+GMR5qNeJ/HLMHK7He+rCgusZBEDQE8YpVNyowqzw5K+YyiGrTlu8p+X4VtWBZLyewqFGi2Le+/tpEfgptP17YZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxqPmvQ3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5C7C4AF0C
	for <live-patching@vger.kernel.org>; Fri, 15 May 2026 21:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778879799;
	bh=7qgjgFxUvKpGr/7MrBVaKHvp/HakTh8FDvf1KsdtDJg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LxqPmvQ37XmgJv0g9FYqqAbFZ4wLw1KWv0esVfhgYnDPcDVFZlyWkNdgR8qw+ry4o
	 QdajIWCniDHrCXqSWmIJisX55Gqby0FdJVvlhWUEV9JuR4oYAEUzGUZQtPI1G3R4r2
	 tC+mymZulXwu7TlHutwXnWH9d6gFS2NSvatyMxjHcTPOh8Msktq3/20gLk5DVelMvi
	 keSWMHCYwuarN2Zpm+Mswl0DYiaiiFSgYZu+V2uZg6Inj1Fg7bm3EW9/1ZjtSKqrWn
	 5h6rmiJbnvOoplz4BmBaXXb7jnUs7kLXbYV6wJnOsuJ8WTEOH+KR9mN294vdaS98V0
	 V3zH4UvlLqYpA==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8b5de17382cso2554056d6.1
        for <live-patching@vger.kernel.org>; Fri, 15 May 2026 14:16:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9Nl+MP9F+run2OEjQ8QSBIjVa/NhSW5vf+N5ay2eRoa/JQZdUbhQkCUev0OTX5TQFqBpVHnS/7BNpGywsg@vger.kernel.org
X-Gm-Message-State: AOJu0YwC/CsK6dQzHC1Py8rgWLVQKHEIisrnqAeqKQ5xeEphCi1laIXN
	nND0pjuXnGao1QHnTpJqIltnVTH/C8UeDMJUapQAbLGU0BQKEfXeXsdT4oKLSJR/Vqf7//SNyvg
	xXlR8HpQqOYVyANl5zJR9AKsGvmjzGHE=
X-Received: by 2002:a05:6214:501a:b0:8ca:190a:8cde with SMTP id
 6a1803df08f44-8ca190a8f16mr56910566d6.21.1778879798474; Fri, 15 May 2026
 14:16:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1778642120.git.jpoimboe@kernel.org> <f32864b560d40894cdb70d613480d7c2ecdb55e0.1778642120.git.jpoimboe@kernel.org>
In-Reply-To: <f32864b560d40894cdb70d613480d7c2ecdb55e0.1778642120.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 15 May 2026 14:16:26 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7ZVeqDoZCDzdahEXSmboC+gA9T4pmUm4hxmutp12h1oA@mail.gmail.com>
X-Gm-Features: AVHnY4INuRGnhlm_RhZATCu11IG0BAUIhjY5JXNgPGnjB1-OrybrKm47hicJN7g
Message-ID: <CAPhsuW7ZVeqDoZCDzdahEXSmboC+gA9T4pmUm4hxmutp12h1oA@mail.gmail.com>
Subject: Re: [PATCH v3 01/21] klp-build: Reject patches to init/*.c
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8101E55814B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2834-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Tue, May 12, 2026 at 8:35=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> init/Makefile hard-codes -fno-function-sections and -fno-data-sections,
> overriding the klp-build flags needed for patch generation.
>
> Don't allow any changes to those files; being init code they aren't
> really patchable anyway.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>


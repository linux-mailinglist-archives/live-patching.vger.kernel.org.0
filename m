Return-Path: <live-patching+bounces-2550-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KnHyEQgF7GlbTwAAu9opvQ
	(envelope-from <live-patching+bounces-2550-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 02:04:24 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9504C4642F8
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 02:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44C0D301050D
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437491C01;
	Sat, 25 Apr 2026 00:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/safXeg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206081397
	for <live-patching@vger.kernel.org>; Sat, 25 Apr 2026 00:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777075461; cv=none; b=N4nAsszuuwIUR6EZjZJtGrSwGQVqwug5e4Oihsfda8GMVmlJ5hq5Al81OJgWfRU99A2IAdX6oZKzy0ETw1bYmp0Oqq+S2Ngfmn8rPSUvxF1P5Ur8XSbslgmHXdRanP2xzmpRyusORozQJ0lNg3y6t4U9FcwIYkTwm7g7saQnqpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777075461; c=relaxed/simple;
	bh=ZK84S4XlR5CYX5IdvwioSYD9v/QAjzT86XT24jdxqKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ra/xessfIehtlHEaMVoQyn9kTrVV+Q3aELTpZwSdtEsA6GIwQAvuvAuzYbEqxewTb5gfSwq1UNS53nfeubNxhenMg9R6Yh3FbSYRCQ5FQgOp5u+4b0tBEBqQo5uPtqEYvEjyeYcqpM3CyoCxOPXNF6p1Sd84Syf+5ZPJgJYN4hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/safXeg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B35C19425
	for <live-patching@vger.kernel.org>; Sat, 25 Apr 2026 00:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777075460;
	bh=ZK84S4XlR5CYX5IdvwioSYD9v/QAjzT86XT24jdxqKg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Q/safXegCVZ6kLLr3N8DyP9Wk56+zNLiNq4ZlhlOchVtDAwEi9mtTLH5s6/d8yFsB
	 c0h97K0P35DjikwRtxIAM5Jiga4TlNVn1QcEEZLlpPmgFuc3dS0L1uR3PhK3ji08Fu
	 rXuszqWVCi9sMXB7AeaiRk60/V/lqdtmz7NA7BeZd33ExGIzyFYsvW/kfGE5G84NjH
	 TJlZgONo7IZ3aRxxuviUlBljHVeRmMaZ4B1JVZvca7joWAhzcCPqJxjNVDs7HynBKZ
	 9r+Grwh4vRV4BDw3glz4lv1FW77y1kF2YZ4GXzxF3fkclJ9JGIcBLxnRbEGvtzctcd
	 lgsPpLUhvvk/A==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cb3bae8d3eso752935085a.1
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 17:04:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/w+jghjWHH9Fr0qVDA+slsPybUq9dICX6IG9VdH4dbN9FfzSwSHn5JUuGgZKDtWffIl33jGi8tZQjFblXj@vger.kernel.org
X-Gm-Message-State: AOJu0YwDNo/a/BuIeS+262ZiXnknaL0m+oCWuf8mm9nEoB5GKxKbc2gb
	1nhpdvXMqEynmyEFdigDQR8plZ2UNPQJL/F8eGepo/WJIQ2koFCBNoVxlm2TqBodBuaNSfV/Yxc
	/LAVsHotsX7dm3toDaag906+bh4uUWPk=
X-Received: by 2002:a05:620a:25cf:b0:8cd:6175:9b17 with SMTP id
 af79cd13be357-8e78f82b5e2mr4928714985a.3.1777075460021; Fri, 24 Apr 2026
 17:04:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <03f7804ae62c5c4521053afc3f6a1c4a11bc85de.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <03f7804ae62c5c4521053afc3f6a1c4a11bc85de.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 17:04:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7=EAeOT3cTvROoDVcvU6wibF56nJFPQzXQhnVcxfmPrw@mail.gmail.com>
X-Gm-Features: AQROBzCb24y4fHn4ZCE7lTFHrV1mGbHA0wpst78EXx2ByDZillffqaZtI6f-G28
Message-ID: <CAPhsuW7=EAeOT3cTvROoDVcvU6wibF56nJFPQzXQhnVcxfmPrw@mail.gmail.com>
Subject: Re: [PATCH 39/48] objtool: Replace iterator callbacks with for_each_sym_by_*()
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9504C4642F8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2550-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,sashiko.dev:url]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Convert the callback-based iterate_sym_by_name() and
> iterate_sym_by_demangled_name() callers to use new
> for_each_sym_by[_demangled]_name() macros.  This eliminates the callback
> structs and functions and makes the code more compact and readable.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  tools/objtool/elf.c                 | 80 ++++++-----------------------
>  tools/objtool/include/objtool/elf.h | 40 ++++++++++++---
>  tools/objtool/klp-checksum.c        | 20 +++-----
>  tools/objtool/klp-diff.c            | 42 +++++----------
>  4 files changed, 73 insertions(+), 109 deletions(-)

Macros are indeed cleaner. But Sashiko has a valid point on this. [1].

Thanks,
Song

[1] https://sashiko.dev/#/patchset/cover.1776916871.git.jpoimboe%40kernel.o=
rg?part=3D39


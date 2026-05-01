Return-Path: <live-patching+bounces-2675-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHIBBf2A9GmXBwIAu9opvQ
	(envelope-from <live-patching+bounces-2675-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:31:25 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E8AB4ABA4F
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:31:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9FE663004DC1
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830263859D3;
	Fri,  1 May 2026 10:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfaHRBez"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604252DA76C
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777631482; cv=none; b=ZJOOMRMQ9zIzE+FF1UgCKs46Yv/dw3Ma8sPN1cp/oBAhCgxxbWDWbebkJPhCRVuVARsimP0pS75FA71EQsjxg9Ab86IgJAjatZo7ultJhpmPFIiKXIUBgjBT6WsgYdVBKAEtw9PJLTSnhI48gsaOdWTvV2Rz7/Gfq4x4qbSd+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777631482; c=relaxed/simple;
	bh=bkhxa34jQ0/l8Or4nfWOCt2LQpGobbilYpsnnKocUqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OVUhEJJZ+E3qFB3nHnAndfwSmCZN6DVkHWWjst+uSqlPTgOxNxXUDwAPM2Wtpf0V9IjhZ2N/u6BABO0rSK4gi7AvrOrh7qtEmUs6hNFFpzUByrO3abat/2a5USKRo6Zmehg3SE862+Sg22ce5NLYE68jarWEQ+KLRlCfVoGJAx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfaHRBez; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10157C2BCB7
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777631482;
	bh=bkhxa34jQ0/l8Or4nfWOCt2LQpGobbilYpsnnKocUqs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hfaHRBez8t9BaW9QHermxSPSar7eBZueNyZyetIwzp2J4fhrzMZYgUQneaC77FXJM
	 yOutuL0vFIFD0glgNHY96jTz0hmJuiI5DKmf3JIxlC46tpgp/51nu0xLVZzYp1IpFK
	 9DurGA3T7xgiAV8BiCsmAmcoYlV/JB5DZco/XT9xCVTN68pywk/W+pk0UcCa2EQJlO
	 HTr/0gaDx8rGvejSW0VBKSldGGzXJGHeeij1DKChqNQJ85AV4fTa3HjgY7fHkrGUrd
	 l+FSbYWZBcmJhwb7gKYS6vjmIbloZyQEY//WP0xXHKeeeXZjos3zTgtKcBJXn1Qa2K
	 JQ7+KvlWQAz/Q==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8b3eab6ec9bso34119846d6.1
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:31:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/EAkjnwB8vdsVIM3pWVHL5c4ieo++UtjEZpmxiP1P00IQBU0qTdq0AzL5OedhiltAStz0Htk2Pz6CY1ann@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6P0cW3OCMWScji4KGQUdvTKot/q8+8ubktZ35EaIuxcyidne/
	Rv2rrcyLR0Eta/bTQCANJTUH6mYRKRPxL8tn3lyeRPrRhqUZh1EEOlG7+RMhMyTGDdmYJhQtIso
	kxCs2+ADeuGX5BH+/PmEZSn5HlmWtPX0=
X-Received: by 2002:ac8:58c2:0:b0:50e:474a:47e1 with SMTP id
 d75a77b69052e-5102d0d3e7cmr75966411cf.10.1777631481255; Fri, 01 May 2026
 03:31:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <9572b2e15500e5ed8dcbaac78c966557d3000d85.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <9572b2e15500e5ed8dcbaac78c966557d3000d85.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:31:08 +0100
X-Gmail-Original-Message-ID: <CAPhsuW7Kcc0a1RYoynrq3U7S1+1B3AX3OCovGa2bs-NgpRoJ2w@mail.gmail.com>
X-Gm-Features: AVHnY4LnT-6bWRm9zsXpiX8OnuQrnX1wjG7VdBzQizTbK2SFm1x-LXCixUH1XlY
Message-ID: <CAPhsuW7Kcc0a1RYoynrq3U7S1+1B3AX3OCovGa2bs-NgpRoJ2w@mail.gmail.com>
Subject: Re: [PATCH v2 18/53] objtool/klp: Simplify reloc symbol conversion
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9E8AB4ABA4F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2675-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

On Fri, May 1, 2026 at 5:09=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Inline section_reference_needed() and is_reloc_allowed() into
> convert_reloc_sym() and remove the redundant is_reloc_allowed() check in
> clone_reloc().
>
> Move the is_sec_sym() checks into the convert callees so they become
> no-ops when the reloc is already in the right format.  This allows
> convert_reloc_sym() to unconditionally dispatch to the right converter
> based on section type.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>


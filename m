Return-Path: <live-patching+bounces-2529-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MBS5EcLi62kySgAAu9opvQ
	(envelope-from <live-patching+bounces-2529-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:38:10 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A20046387F
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47821300A8C7
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1EE3E557D;
	Fri, 24 Apr 2026 21:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHvBuotV"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BD73E51CE
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777066686; cv=none; b=TD2jxs4+HTPtp9k/krwhTTavsyW9KOuIjaRoynfBfZ3ymEgLdCBCiZGx4dk0OGD96QzrHGVf9Q5iPLOrn7mM8vczYCy0EviX3BbGP4bvmU7u+ptXK0IPKDRBCL6TcYG9i+H4YNDSkFg3+AztnwrWEUn1IeYLccMjVrdcqXr+4mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777066686; c=relaxed/simple;
	bh=lEB/1D5Ncw1MqZBQWILMHoOxvmJ91iyQ7aN/Y0EMPRI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AIqs0CbFaU5qOHbbtzEk76KAA6jBwY33UFc2lIADjkGcBT6mSbp4Yev3IrFNFIUgHVnJt90QdHJGCRWe7L88sJfP7+vo2o0B5nj8rB42vkIgjoASa8MffpYal1YycfFfIvWnxtY9X8bGiqU4deSUO2P4UDWskTLJDB9uz0hgnQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHvBuotV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FAFC2BCB6
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777066685;
	bh=lEB/1D5Ncw1MqZBQWILMHoOxvmJ91iyQ7aN/Y0EMPRI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GHvBuotV7ffMLeTmLeS9n0SKuNZST4XuQlFRaI0/K07s9L2U7blxoQzaMlSMtXm7r
	 CuXTZECqhswq93KRI0XOm2Od6QfPVy0gtHwet8jDThOLAGf9knHaJIxIrLcLuKlyp5
	 F4ACwMLpfIf3ROEdvhyZwfdwi7TBTaj/ajwply0FgU00FHdXTVf5hjAa/ic+YLjSP+
	 8N6IGKgZDulqknPtWpqEcEklMBF0pvI9pqHt64FaibahH88qrGjLotIP867/pURDu4
	 TDyAQESeY2W/6Y/xDgbjOuCGRc4+QZ9j5E56aGpjyJUkkRd3XcRdw8jSbOIUCifVNH
	 oKQrxzxSR1UlQ==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-899a5db525cso65571246d6.3
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:38:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/fqbm5sOp17ja7N/vApBRNFIBo/h/+BdX4iK89p/nX/V7maZXiWtQfSJjmhT40Rg1hl9BNsfx6RTQLg6Tu@vger.kernel.org
X-Gm-Message-State: AOJu0YzzzjSNoiIfIqnnoBBt2hKo+gCm/L9lBw60T2RGnT6pz20qCcfD
	l61Rbg35P20K8dYIvbGUqeU/UkS5J4YF2eTdmXqnTv7b9xaWQ/NNG1ZH5VfsyLnxKieuEQJNYIH
	cSgXI8vmAuOFCofq7h7d2NgWo/f0Yefo=
X-Received: by 2002:a05:6214:2521:b0:8ac:b6d7:e60b with SMTP id
 6a1803df08f44-8b028013c49mr516067736d6.1.1777066684800; Fri, 24 Apr 2026
 14:38:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <5e67de043745aec66abf963edbd74d13c5ea142a.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <5e67de043745aec66abf963edbd74d13c5ea142a.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:37:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW68OwxjVyES_Kup6OEycs1Q=p8=WtsQPePcfnw+w_SQiQ@mail.gmail.com>
X-Gm-Features: AQROBzDwsm4keeW58Bex4bPh0w41tjRauv7FaDAmZnic2rDIOpsG0OZ8mh7kGbk
Message-ID: <CAPhsuW68OwxjVyES_Kup6OEycs1Q=p8=WtsQPePcfnw+w_SQiQ@mail.gmail.com>
Subject: Re: [PATCH 14/48] objtool/klp: Fix extraction of text annotations for alternatives
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9A20046387F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2529-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Objtool is failing to extract text annotations which reference
> .altinstr_replacement instructions:
>
>   1) Alternative replacement fake symbols are NOTYPE rather than FUNC,
>      and they don't have sym->included set, thus they aren't recognized
>      by should_keep_special_sym().
>
>   2) .discard.annotate_insn gets processed before .altinstr_replacement,
>      so the referenced (fake) symbols don't have clones yet.
>
> Fix the first issue by checking for a valid clone instead of
> sym->included and by accepting NOTYPE symbols when processing
> .discard.annotate_insn.
>
> Fix the second issue by deferring text annotation processing until after
> the other special sections have been cloned.
>
> Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diff=
ing object files")
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>


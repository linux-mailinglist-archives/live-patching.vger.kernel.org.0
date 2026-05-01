Return-Path: <live-patching+bounces-2673-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHoUIAeA9GmXBwIAu9opvQ
	(envelope-from <live-patching+bounces-2673-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:27:19 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA114ABA10
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70D0E300B619
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8058C387378;
	Fri,  1 May 2026 10:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wwmual/N"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC68386C3D
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777631236; cv=none; b=Rd1ITaaqIKJHoU7aEVB72Krmj6rnhGZ7/zypjJrT1k/c16bUUnN2hgl6LNTlItY3xdMdmieWYPSuhOBGL8NuRRaxjrNeJx8fG3CZBuaIRYGnjOBHXrUCjRWeHcQmkbe2MhFDPHad9qET9TzNZ1f5S7TENYLYGfgwZP12BkFXkAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777631236; c=relaxed/simple;
	bh=Shxx+gNxHbDZpCd2nFhWHfZva27eVWs3VKTJZ3RQUAw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fwpfyv+uIdDMtm3azv5Vyai5UuI86xhKoCfKWGkZhCPU4jxVkfufYV9jEhCxEQup3PGv5gbQy7TreSZWC7HTZNPwhS22K0OxQM8/VQatLy3W/7mtQ+rVa/tq7p0tSOqCwh8ymzr3pbdU0J335do5SQayBuTehIpUhoaNDfT93DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wwmual/N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A0AC2BCC7
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777631236;
	bh=Shxx+gNxHbDZpCd2nFhWHfZva27eVWs3VKTJZ3RQUAw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Wwmual/NXZRDc3qoICrE0L0OaKlLBydcYiSTmDM031aFqgdbRRR3/xTw6DnT6QvdJ
	 VZnayhUFT6YOY078jraNjsOFOO5CU0DlA3YVI0JYcyMLg8aurmsO0pGi67g5Iy68D9
	 sJZHJugYkPfBEiK0U5SpNHfBdA3hUY1VLKlYOc86MEhMJ3raANTuKkw0kkbb91qYL0
	 LT6Ov+p9YXZ5H2dBWNm18zXWDvS4sQwHs8uCpFilVPMHEBbE8EBHQ46gvxholW5y9f
	 ntmFRk961n2occfYNwM61lin7UApa+OkypgL0z3CqUN6vOyWpvvzffoSgGDKetI9+K
	 tX67ioQ5bmD/A==
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50d876329bbso14296271cf.2
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:27:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+Rj3e68x0UURIEy0Lw5t3JEXfI8fwBMyylLiefe1WnGAhVki+1xrm0SuNRVbRL/nzrNmaGZQ4oIfWDifVr@vger.kernel.org
X-Gm-Message-State: AOJu0YxeGLaFOtJp1neNkOtOJLWhscZoniFm6LYb9I+nQ4kAwyZ0ykXx
	XjkBXJz/YxFOk7Fcqdceg1JQILIbeKyVzmBrtAGaiQFa4uDWPpXsP2RkmF40zdGdeZlanlgjr3t
	PF+9bnSWlLNNb6ZxDRbPQlah5eSUJELI=
X-Received: by 2002:ac8:7e84:0:b0:50f:bb77:a085 with SMTP id
 d75a77b69052e-5102ab353ccmr101542521cf.12.1777631235245; Fri, 01 May 2026
 03:27:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <54175a1446aae952ad4d886eec3f64fcbdbeb375.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <54175a1446aae952ad4d886eec3f64fcbdbeb375.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:27:02 +0100
X-Gmail-Original-Message-ID: <CAPhsuW4EA3mnu=1cohiJLczR1ZaSU0djfkn=FtsCU-s5FLO9NQ@mail.gmail.com>
X-Gm-Features: AVHnY4K9-6xACyyUKtm8tAyfUebM2oPTg-ZrnF7klJMDdompjetsj9GC1VuMwtM
Message-ID: <CAPhsuW4EA3mnu=1cohiJLczR1ZaSU0djfkn=FtsCU-s5FLO9NQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/53] objtool/klp: Improve local label check
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CEA114ABA10
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
	TAGGED_FROM(0.00)[bounces-2673-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Fri, May 1, 2026 at 5:08=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Clang emits various .L-prefixed local symbols beyond .Ltmp*, such as
> .L__const.* for local constant data.  These are assembler-local labels
> not present in kallsyms, so they can never be resolved at module load
> time.
>
> Broaden the check from .Ltmp* to all .L* symbols so they get cloned into
> the patch module instead.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>


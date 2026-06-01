Return-Path: <live-patching+bounces-2936-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2GDXF0aUHWqmcQkAu9opvQ
	(envelope-from <live-patching+bounces-2936-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 01 Jun 2026 16:16:38 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56E70620A54
	for <lists+live-patching@lfdr.de>; Mon, 01 Jun 2026 16:16:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 98E553076EA0
	for <lists+live-patching@lfdr.de>; Mon,  1 Jun 2026 14:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CF53B6BE6;
	Mon,  1 Jun 2026 13:58:07 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417AA41754;
	Mon,  1 Jun 2026 13:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780322287; cv=none; b=NtEQQTcGJgxcjfyat9ctoCmvxjRnCuH97nInZhnxUhNHMWwEMs7Z9llylb7Y5z6UsTWefKZDRBjjnfkLKT4o5TjOK2qbZmm9uzJ0RTLIwbTYOSQax313FGElZUJeAEocsqXv6UuNiY9P2Hdafp7kJxgC1JjDizk8Nn5iga/LKOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780322287; c=relaxed/simple;
	bh=4R1Hbrrpcy1HtUgm6ZfYAYZAmE7OzcXwNeFg+EICPV4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FrvqgRoitFokcWUfb2AlsAQn1mIamv6zIUUYmxfxNMw5ZCcHNsG2hjFD1kTkbFtei1CxbVQNVIGiK8NxAWOTS04Uoodd/wdVYxvr1w3fX2AAM7S+VOxzi0jrYtVAejp4iLYtfldNTRtSkpDkBrTOrm721ydZgTB98NHM9UcSFV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62784C25AE;
	Mon,  1 Jun 2026 13:57:56 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 559FF2000F;
	Mon,  1 Jun 2026 13:57:48 +0000 (UTC)
Date: Mon, 1 Jun 2026 09:57:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Wang Han <wanghan@linux.alibaba.com>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Chen Pei <cp0613@linux.alibaba.com>, Andy Chiu
 <andybnac@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@rivosinc.com>, Deepak Gupta <debug@rivosinc.com>, Puranjay Mohan
 <puranjay@kernel.org>, Conor Dooley <conor.dooley@microchip.com>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, Miroslav
 Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe Lawrence
 <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 oliver.yang@linux.alibaba.com, zhuo.song@linux.alibaba.com,
 jkchen@linux.alibaba.com, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 1/8] scripts/sorttable: Handle RISC-V patchable
 ftrace entries
Message-ID: <20260601095746.70c01d24@fedora>
In-Reply-To: <0a913398-3d0c-472e-89c4-062052eae04d@linux.alibaba.com>
References: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
	<20260528082310.1994388-2-wanghan@linux.alibaba.com>
	<0a913398-3d0c-472e-89c4-062052eae04d@linux.alibaba.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f447gedbzrerco4pdpduczfnka86u36g
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX194pc8QTmXaS/d93wdj0DvE5EOOw5sTtk4=
X-HE-Tag: 1780322268-32769
X-HE-Meta: U2FsdGVkX1+yVgV/w52pVzTLLqyvVAY9J7gVdB5Q1WuUAGM+lsRLxst53oCPsODAVFZnfliDVWsZcm6mLFinY/0IjFZHPb7CSMn8LIhKh7qtGtlpAjvpgVz4uEBhr2YExi/iahHXazkS5LqTxk2sga2susKYFqYsc4ZedAO9lXwWAiEiEvtBok619UN83VMlbMMYI5ORxSJkORJrEsagLayD4xVGn8q5hyVAdJgn5WRHWqMyFrDA/DRy3tn1I75zMJ/Vb6ubTTbSu1X1UsW4R0NdWkcWDfgaW6x9dkOznSUkBNMTIweGHS+UG5tNc9VWEeDvYkqEtJpT6v4X4SdrJ9Vr1t1Z9Yhd
X-Spamd-Result: default: False [-0.86 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2936-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[34];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[linux.alibaba.com,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,arm.com,gmail.com,rivosinc.com,microchip.com,suse.cz,suse.com,redhat.com,infradead.org,lists.infradead.org,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.978];
	TAGGED_RCPT(0.00)[live-patching];
	R_DKIM_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,alibaba.com:email]
X-Rspamd-Queue-Id: 56E70620A54
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 1 Jun 2026 14:17:08 +0800
Shuai Xue <xueshuai@linux.alibaba.com> wrote:

> > diff --git a/scripts/sorttable.c b/scripts/sorttable.c
> > index e8ed11c680c6..4c10e85bb5af 100644
> > --- a/scripts/sorttable.c
> > +++ b/scripts/sorttable.c
> > @@ -891,17 +891,21 @@ static int do_file(char const *const fname, void =
*addr)
> >   	table_sort_t custom_sort =3D NULL;
> >  =20
> >   	switch (elf_map_machine(ehdr)) {
> > -	case EM_AARCH64:
> >   #ifdef MCOUNT_SORT_ENABLED
> > +	case EM_AARCH64:
> >   		sort_reloc =3D true;
> >   		rela_type =3D 0x403;
> > -		/* arm64 uses patchable function entry placing before function */
> > +		/* fallthrough */
> > +	case EM_RISCV:
> > +		/* arm64 and RISC-V place patchable entries before the function */
> >   		before_func =3D 8; =20
>=20
> Nit: The shared comment now sits under `case EM_RISCV:` but the two
> lines above it (sort_reloc / rela_type =3D 0x403) are strictly
> arm64-only =E2=80=94 they configure the RELA-based weak-function fixup th=
at
> RISC-V does not need. On a quick read it is easy to wonder if RISC-V
> is implicitly inheriting that path. Splitting the comments would
> help, e.g.:
>=20
>         case EM_AARCH64:
>             /* arm64 needs RELA-based weak-function fixup */
>             sort_reloc =3D true;
>             rela_type =3D 0x403;
>             /* fallthrough */
>         case EM_RISCV:
>             /* arm64 and RISC-V place patchable entries before the functi=
on */
>             before_func =3D 8;

Makes sense.

Care to send a v3?

-- Steve


Return-Path: <live-patching+bounces-2506-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDRkJXux6mkWCgAAu9opvQ
	(envelope-from <live-patching+bounces-2506-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 01:55:39 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BA70F458749
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 01:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 54D013008D11
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 23:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FDC3B2FDA;
	Thu, 23 Apr 2026 23:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVw28ng0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB6A35F164
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776988502; cv=none; b=iim0Ln6QBfrZDXjN5OeMOcgvIW3yTHFXkwOb07OZndQAlGJg1sXusfL49OUEgz63gyQiZwUX3jTVmyC7R2QIKDA1eCI/bqCIHIoD0GQ8LAEQtTaENf4jUqFgdVX5i2fAoAr7SWzuHaCkoe2yXgOjXSHe8mL2zk6tE/RIk5B8Ci8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776988502; c=relaxed/simple;
	bh=S9d2jy8y7PXxhRVjhahQpk+3FIaibGwpIgRrutq3g5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BzCD+8mo+LvFICgdOyS3PJzmEcWoe5fSolP2eN/ouvU4clzciQ1Vcy1bywhN/0SYEDwFJalDDIg2lSRPqdOVs3WyGRV8sff7RFCXU3P7J9ZfB0DQYNjhbFHx1QL9cDOhlRAkAukY/hGY9/bX+MQ4ugW6eI+Wl6YdkkVeTTOP76o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVw28ng0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2494C2BCB4
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 23:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776988501;
	bh=S9d2jy8y7PXxhRVjhahQpk+3FIaibGwpIgRrutq3g5U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aVw28ng0LAZVJAJjAj2hwO6KlH6hutAomG6Bwmg/dFMaqDjomr24m49VSk3fneCni
	 U/3rJ8DTNc2UeJaYd7LmZ5/Yr+eQ7G9V+umTC5uwrMUUfE12W0kmhEQqG+R0hm0Qqt
	 29VyEhz/3gJPNmirMhc+C8EIPtFzIeB4xjo5vE2Q5hJDOhD/fLtvdl0X0acwfCmmte
	 HSJ19XstJ3Ok4M5c3FQOBJwJ+W5kzPiXqlLCRZ9vNoNyc3AH4hzdXy6H+6AjnF9Ms9
	 PaunJnsSYwN+7VLYghmed9xiFCuhSCkvgf9xXWbPb53OkUZnn1npWxd3wJeVye98j7
	 h2nfjJjlD993w==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8aca2726f61so86436646d6.0
        for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 16:55:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+Ow0YHQ3Iygocl49UyeXwmPOchvB6OT8AnACyT3rnICyVAKa3jkBU6ptnbdXeTxC+Uj8peFiBlkpRhltGa@vger.kernel.org
X-Gm-Message-State: AOJu0YzOvEjPhPXvFI9MjF8yw8UvoE+8F010lgGSwAzQpAconxsLkoYU
	4A73Vx3pQ8OX1A/Bicgd1pvWk8FG84BI2BKNoj+9jV0UeBrYNV422scvah1gfRT8zkbCeGOJ2zF
	KCzjEyOZ1hK+z7WhgdDu0twxrL1POD5c=
X-Received: by 2002:a05:6214:43c8:b0:89e:a170:6af2 with SMTP id
 6a1803df08f44-8b028126c3emr446041286d6.41.1776988500816; Thu, 23 Apr 2026
 16:55:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <93c7c80130375edd22874a57cdea132b0edbb0e4.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW6_FzbAeqOduv56jZEk2E1xm+RqAxOHdekUHJwezvGOyw@mail.gmail.com>
 <gmjxp6lzlwjfdp4gf2nktoqfwrdx4bapf2mnnezo2gjyjj6yqf@if35zh3xa7t6>
 <CAPhsuW6VWk43z+BYCYRxo56w-4VKw8W3nmvVfCLh=ouN7a2Cqg@mail.gmail.com> <l6spha5o4wl5ksczovjwxghb5lhe4parswxhtzk2ac4inxmmhc@h2hiehwqkgmx>
In-Reply-To: <l6spha5o4wl5ksczovjwxghb5lhe4parswxhtzk2ac4inxmmhc@h2hiehwqkgmx>
From: Song Liu <song@kernel.org>
Date: Thu, 23 Apr 2026 16:54:47 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6RZhwr2rWyMoedUEOXaRyBCyAwjwefrhz2dD-ukdLK9w@mail.gmail.com>
X-Gm-Features: AQROBzDBdX-8_pfSYW6eEiiL2VrZbgvI86JgrFyuSOt2pv_jJCGgUzOA33VL96w
Message-ID: <CAPhsuW6RZhwr2rWyMoedUEOXaRyBCyAwjwefrhz2dD-ukdLK9w@mail.gmail.com>
Subject: Re: [PATCH 04/48] objtool/klp: Ignore __UNIQUE_ID_*() PCI stub functions
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BA70F458749
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2506-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]

On Thu, Apr 23, 2026 at 4:50=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Thu, Apr 23, 2026 at 02:33:00PM -0700, Song Liu wrote:
> > On Thu, Apr 23, 2026 at 12:31=E2=80=AFPM Josh Poimboeuf <jpoimboe@kerne=
l.org> wrote:
> > >
> > > On Thu, Apr 23, 2026 at 12:05:03PM -0700, Song Liu wrote:
> > > > On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@ke=
rnel.org> wrote:
> > > > >
> > > > > With Clang LTO enabled, DECLARE_PCI_FIXUP_SECTION() uses __UNIQUE=
_ID()
> > > > > to generate uniquely named wrapper functions, which are being rep=
orted
> > > > > as new functions and unnecessarily included in the patch module:
> > > > >
> > > > >   vmlinux.o: new function: __UNIQUE_ID_quirk_f0_vpd_link_661
> > > > >
> > > > > These stub functions only exist to make the compiler happy.  Just=
 ignore
> > > > > them along with any other dont_correlate() symbols.  Note that
> > > > > dont_correlate() already includes prefix functions.
> > > > >
> > > > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > >
> > > > The actual change appears to be much bigger than the subject line.
> > > > Maybe rephrase it a bit?
> > >
> > > Hm, in fact this is a relic from a previous iteration of the patches:=
 it
> > > longer fixes what it claims to fix, as __UNIQUE_ID_ (other than
> > > __ADDRESSABLE()) are now correlated.  The claimed issue actually gets
> > > fixed later by the rewriting of the correlation algorithm.
> > >
> > > That said, I still think the below is needed, I just need to rewrite =
the
> > > commit log.
> >
> > Agreed.
>
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> Subject: [PATCH] objtool/klp: Don't report uncorrelated functions as new
>
> Clang LTO uses __UNIQUE_ID() to generate some uniquely named wrapper
> functions, like initstubs.  If they're uncorrelated, prevent them from
> being reported as new functions and included unnecessarily.
>
> Note that dont_correlate() already includes prefix functions, so prefix
> functions are still being ignored here.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

LGTM.

Acked-by: Song Liu <song@kernel.org>


Return-Path: <live-patching+bounces-590-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD09996B6F0
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 11:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E06651C219C4
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 09:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9351CCECB;
	Wed,  4 Sep 2024 09:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="d/5+gz3/"
X-Original-To: live-patching@vger.kernel.org
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF301CCB29;
	Wed,  4 Sep 2024 09:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725442683; cv=none; b=S7beYfLAdo1qtCcT/0z+fKideO7EVJmUYux2qn3jWs2yqE52p6CQEUzHmk+JwmW/Nh5cdxRPjoww7h8ye2Z76/CgKw6cH9vxs1Lfe5OBryt4OPJqSzDzIjW4kGUB05VMK/cHvRMXo1gNeExF01H7+7VA+ixr1zJ7WQB8tkOhaL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725442683; c=relaxed/simple;
	bh=xKGfFisBUlLlBC9V4tz/6if5ruOEIla+KA6DvV6jvc4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TUTQg5AgJd7iilTV+9q/kNpvqcW8i8V/50OopS+Ek6J/7WzfMj+ueZaPMwa9qq2wMt/dlBx/AShwEmD5/s8wJEue57H+jT2Xe/VkTd0WqN54KzDWM1MmGc0G/VnMpcoQsns6FuIT4taGyhnBKdME1/MNDY/nodCnkAfFqUBvKsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=d/5+gz3/; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1725442676;
	bh=xKGfFisBUlLlBC9V4tz/6if5ruOEIla+KA6DvV6jvc4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=d/5+gz3/S9Hg4V6+K8omviN+NIQxASqhNTzwMbRvuUsmcZcuWHO4vFSgEEoIAENGn
	 RiRXKFtoqIqCQwW+ASCKYL5v8YFqxKHtrapDhQqEXdRv6Bd0VgEfCrXR5WTKlauTcV
	 cVOE37v6eU2NEHEUJSad5yxi5jxDU1HijCzWQgnE=
Received: from [IPv6:2408:822e:28e:6c60:9a27:a20e:8078:6e28] ([2408:822e:28e:6c60:9a27:a20e:8078:6e28])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id 61631C94; Wed, 04 Sep 2024 17:24:22 +0800
X-QQ-mid: xmsmtpt1725441862tza9uo2n8
Message-ID: <tencent_65EFC9C0B6F4B36D24BFAFBEBEE912D71A05@qq.com>
X-QQ-XMAILINFO: OQhZ3T0tjf0aGgKeyvuVyBUliCo4NoTRW6IV4kNy5yBaH+Z2LtZUEb5tudN6y+
	 TCXTg1l0Hri5WxPI8BKQe+guVNw2PhUa7NQhs1B/Ib7M/WOxf7x+NpgurGNX6xT+IcZL04nKouWu
	 aKKBOCEBtEm0aKGElMjA1PE5hcdiHxwBmLnNRamEiAhyx/lYW6lhZ9lmoUNS1DF73kvNTlpfwBmk
	 Y/BiQQ/E4i5Oy4EN2i4OOr6hu/n0oa2RLS+FdvnCNEaQiluBVYoASBwsULGQ8OlKKZQxFbfZ76qv
	 iJ0Bo4RIGn74Cm3bStSCaVe1uEha0SbzctOdlybLf72EE+sNMCqlFDJA6aogoI76HoCFy3KDayyj
	 pmEp5hzTJ6tauconPgVIiLpQQXoOlou4M+D548w5pzW0FLSGceUlhGqPIZOCI6qmksTlwhVDXD+3
	 1fSJKvB1LNFk59KbR3n0QFOYp53MhD9dGPz24CMkY1oxc+GqHMTZP3uf0gJcKBtxLtL4rj2RnhF+
	 jauiUa3pRzY6+mJWHy8nwynpxqG4HN2jIaLl7BUUfUpPk2rcxAgSG536yCV+AKFeuD4oyn3k1tjZ
	 +jfgDdEZetOjdFpkUbARKKFStE0q0jZ1YJSreAHBRZutAqpe/MAUU+PcDWw3LHUkY3Jf17wl0NKv
	 jIbLZHwK6Wh2ehvgBoJlOOGQMwZxBTsrmSH6B1mJC1aKjLi+mfH1n1ecp3dP10u576oVv6c1v6YO
	 WExM2gukbm0OiPf4g0o1aHa6hVHZlafEx8IC+l7dWFBukIh4qvIqn3PaXvQJuca2vLPzqvX94qwF
	 llbGLbPVuEW5pZIGjbvw2hceU/DKhRnATvKca4GvO+Tvt0tH65tRCZE4S/EhrZ3NJ9w0GaMVKCil
	 HO0a4tooCz+7APcG8Hl+2Md/J01Wpek35QRImcFzk3aWzxVl4cbLBQXCiGHFFwFXSuoOCjigVK
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-OQ-MSGID: <79261beda62e69c379023b91140261ed73cf42ca.camel@foxmail.com>
Subject: Re: [RFC 21/31] objtool: Fix x86 addend calcuation
From: laokz <laokz@foxmail.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Miroslav Benes
 <mbenes@suse.cz>,  Petr Mladek <pmladek@suse.com>, Joe Lawrence
 <joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>,  Peter Zijlstra
 <peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, Song
 Liu <song@kernel.org>
Date: Wed, 04 Sep 2024 17:24:21 +0800
In-Reply-To: <43433a745f6db5afb513d015a6181bc40be12b4f.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
	 <43433a745f6db5afb513d015a6181bc40be12b4f.1725334260.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-09-02 at 21:00 -0700, Josh Poimboeuf wrote:
> arch_dest_reloc_offset() hard-codes the addend adjustment to 4, which
> isn't always true.=C2=A0 In fact it's dependent on the instruction itself=
.
>=20
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
> =C2=A0tools/objtool/arch/loongarch/decode.c |=C2=A0 4 ++--
> =C2=A0tools/objtool/arch/powerpc/decode.c=C2=A0=C2=A0 |=C2=A0 4 ++--
> =C2=A0tools/objtool/arch/x86/decode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | 15 +++++++++++++--
> =C2=A0tools/objtool/check.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 13 ++++---------
> =C2=A0tools/objtool/include/objtool/arch.h=C2=A0 |=C2=A0 2 +-
> =C2=A05 files changed, 22 insertions(+), 16 deletions(-)
>=20
> diff --git a/tools/objtool/arch/loongarch/decode.c
> b/tools/objtool/arch/loongarch/decode.c
> index ef09996c772e..b5d44d7bce4e 100644
> --- a/tools/objtool/arch/loongarch/decode.c
> +++ b/tools/objtool/arch/loongarch/decode.c
> @@ -20,9 +20,9 @@ unsigned long arch_jump_destination(struct
> instruction *insn)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return insn->offset + (in=
sn->immediate << 2);
> =C2=A0}
> =C2=A0
> -unsigned long arch_dest_reloc_offset(int addend)
> +s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc
> *reloc)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return addend;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return reloc_addend(addend);

reloc_addend(reloc) ?





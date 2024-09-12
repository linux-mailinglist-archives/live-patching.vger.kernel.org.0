Return-Path: <live-patching+bounces-650-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9C1975EFE
	for <lists+live-patching@lfdr.de>; Thu, 12 Sep 2024 04:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 791211F23128
	for <lists+live-patching@lfdr.de>; Thu, 12 Sep 2024 02:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3203364A0;
	Thu, 12 Sep 2024 02:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="BrxBGAry"
X-Original-To: live-patching@vger.kernel.org
Received: from out203-205-221-236.mail.qq.com (out203-205-221-236.mail.qq.com [203.205.221.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EA444C6F;
	Thu, 12 Sep 2024 02:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726108802; cv=none; b=OYXLZzJVYQMC7iRWtPuFzhnNgaygquM3ZMXQAYwuDU+V81V+nxlaqPaLQp1ILDZ3s8aqnJBLyWQgthudwI/ZZ/sHCSehL5iA7O0cpGg8iEt9+zrM7kPDuq55CpNegOldR2C9esWH7thdFJx8Cf1MKMoLslMAA0pjDc9LQOhNyOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726108802; c=relaxed/simple;
	bh=N9eKvYL31VlOmAHgJWYX2vdviwwhwTTRrC/zbQwsKYw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cUp7/kwOKCRKsqtZT3l97OF4hf0bilndT6GSXT+5aozuXZ5wms1oIZHFQfTEjUtTGbwM0F1jWZLhwb2QQb1bAs/3kmgsxIgK+JkGSKnXLRfHJU54XohThuvDx34OZDo0M8w+PoVkGOhysGl1pbwzcZam37hu4jspvpL7uULFPcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=BrxBGAry; arc=none smtp.client-ip=203.205.221.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1726108791;
	bh=N9eKvYL31VlOmAHgJWYX2vdviwwhwTTRrC/zbQwsKYw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BrxBGAryc4wo/MMWHqlPuIHMnFeGrPFBmTshrRZySOpOkeiNjPpLrm/EOyMod5MOk
	 WeKlZi+D0Su9D4+cDQCco1dp3HVHZqZYHhNeG4XnpLnBia8NXhq6rFUezjPdXlsmSd
	 iu8OVPNnHZTbBQ9h/yJW0cS+aTRW0Czm3OeUlj94=
Received: from [IPv6:2408:822e:281:3c20:a945:8b5c:398a:b7a2] ([2408:822e:281:3c20:a945:8b5c:398a:b7a2])
	by newxmesmtplogicsvrszb9-1.qq.com (NewEsmtp) with SMTP
	id 9EF04A63; Thu, 12 Sep 2024 10:39:47 +0800
X-QQ-mid: xmsmtpt1726108787tg7zebv7h
Message-ID: <tencent_7FA7E9159716AFC740AEF4B86D359FA59E05@qq.com>
X-QQ-XMAILINFO: OfaQ+Y0DiXSPPE7wZ5mvr53rUrYL6Iacd+ojMicgGMNCy7vObeIfjQ3IKjA7Lx
	 C2YG0jApNHemwmng6JeY6kGfxIaTB+LELhNlC9TjUFZ33HMLJmcACKqQhfgrac6VxJL9ypgh3pp/
	 wm1geWK4BBklJozE5ISRUa4N6GCo6ZIITQIQYWSWT5fwOOZ6WBzksx5wi7dSNKNnjpQGR3xEz5hu
	 DYZNg+o7Bo4s0/D6gY3hCM9APzZSribAdXh4QfnHGIKwGL0FpKzEyib7X9GCdd/xROMUaQiZXqs3
	 EeHujxWxLqLs+PzCkgXBddyGLunyPgtvQSVHnRsTNJ8kJcZEYDSOoP8XsA6G9UlN06rbbFWqQ/26
	 fcq/ng5gjRUxBopAblK5jBzslstbowSmA5/16gdzYc/+LxTy+G7iG6W4Vh0mnYS6+5IgCZy1ettb
	 SeCYLY28Ace5kI1hwR9I7+679nsvCQkT7wX790HboA9lDbEFiYjUOqR05n3hxW9ZMcQd8PdCI2fW
	 iAfFZzXbSTDm/GsIdf9DjVHLTxlLPYZmNNgRnIcLVKoGDN7nyKHm7CU/50Q4SV15tzELTtckt9Qd
	 Tp169pe5LtdV+sToxmCocpubOvLiAe2Pf8U1EZTfeTwY/FOJZxqJq6ZChQEDaqEH2uD8MvUWUMkr
	 FJT7ukCAb79937Hyi3zK02UPKugLOffVTe5sEaoBIssq1j6B1JIqIAJsGqjHxZm04Ir/oQqe/VO0
	 YYTExEobi0nB4pATuZ0mwCvpWxkZ4hyXL4PqCrZP5GuEIbtAXTb7BnIcNSoIQj1QtEmBp4KtKrWe
	 OluaMJmWITVEPuZsrsg+R4Vl91OMjBhVWNjKtw5RBQ1AIYNPCSkjjWKt9hN0DMHwyUbGqjZOjjtf
	 vjurniBL/LXE3mCOdag7eYBYjX2uQNFaYUxo+KlL22sbGqNjOYzgkaWk83N0HqGPcjtdaCHCZ1
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-OQ-MSGID: <65d78ee3dd0e56577e7d2252670e2fd769e19d0f.camel@foxmail.com>
Subject: Re: [RFC 31/31] objtool, livepatch: Livepatch module generation
From: laokz <laokz@foxmail.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Miroslav Benes
 <mbenes@suse.cz>,  Petr Mladek <pmladek@suse.com>, Joe Lawrence
 <joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>,  Peter Zijlstra
 <peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, Song
 Liu <song@kernel.org>
Date: Thu, 12 Sep 2024 10:39:46 +0800
In-Reply-To: <9ceb13e03c3af0b4823ec53a97f2a2d82c0328b3.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
	 <9ceb13e03c3af0b4823ec53a97f2a2d82c0328b3.1725334260.git.jpoimboe@kernel.org>
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
> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> new file mode 100644
> index 000000000000..76296e38f9ff
> --- /dev/null
> +++ b/tools/objtool/klp-diff.c
> ...
> +static unsigned int reloc_size(struct reloc *reloc)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0switch (reloc_type(reloc)) {
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case R_X86_64_PC32:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case R_X86_64_32:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return 4;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case R_X86_64_64:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case R_X86_64_PC64:
>=20

Better separate to arch/x86 directory. Put different architecture
relocation types all together looks a little error prone.

Regards,
laokz




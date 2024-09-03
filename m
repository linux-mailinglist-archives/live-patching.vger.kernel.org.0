Return-Path: <live-patching+bounces-571-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26C8896A576
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 19:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D88EC2885C9
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 17:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69DCA18E036;
	Tue,  3 Sep 2024 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSHIN4t3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7EF18E035;
	Tue,  3 Sep 2024 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725384733; cv=none; b=lqcr0aXzMx1i07YmrGUxyXtxHGKcmVcgLm1OFJlGoPS9E5pJV5JI8NldAonMcZSC8ANa4WarMHT8NYuA4H7vnxQSCU08QIW5jtJaykK0+TuWvIsqemetO5P4R0G8CYz++aQd1pKsqG5uUODKZVz130XCHaIYefKSkaW3DVwgScw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725384733; c=relaxed/simple;
	bh=TvU1cxVBD7PxjncAWiclu2mkmdSigxT69MyYBnJlHmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GVIwcb8/sy/XeRwXmH7n6JvKTsiJgdHov1D8ThBzXfdoKlxMfAZ4CKUwVSVu6Mmvg5ILuHwEyreuIfo/NkKcYfCGlPuNsVsJREDXDxTeFCQOt/hshODXYZMf99fwM6V9iFDrCbdOvLVFvbRnCZc74NjmVyTizU0oy/EPjX65FdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSHIN4t3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4CBC4CEC9;
	Tue,  3 Sep 2024 17:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725384732;
	bh=TvU1cxVBD7PxjncAWiclu2mkmdSigxT69MyYBnJlHmo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PSHIN4t3VMQLiX1QV4JI1Pn5Ao+UGUSomElcsJm62gDNvbnNiBOMnk0+C81lel8E/
	 O4Mr6UC8WetU0IiCpJWqAUzDQNqG2GCygVPI8Qqfe3yQNjdqNNDF9PKR4jsavvFH20
	 5/OC30QQ5GBmBuQ7zkQIaznzRD+DRtPnhmJN6YK6LQ51FPNntvkGCu2YGeO0CwSK2H
	 5G4IUsW8ld8Uf7Lo55WpqNoTEzi6D6+UlRawCBwU1x5zaGxM9nJjURdvpAXAWMMPhG
	 uHaEPDUgyGn6lCUTRjMZWw2zptVs+ty01NAPHQwOWyegm9EXhDNeJMFIMpdT9KFoR0
	 3g9by+5GufpKw==
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-39d22965434so19239105ab.0;
        Tue, 03 Sep 2024 10:32:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWfoKrem3/eOqNVnvZNBdR7nwk9NbUbsWHGULKBB9NKtqwdhAWIfIdxudyZqrVVvhiZKzfQzqNiPraC+vQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoAr64XRT9cJV7KkVp+JiC8s/41HAnRZV0OCkdJ+P/tNkXwuDG
	HHLNc8Qn59JWYFUopuDM1mYDvJSdsRIldBlaXIGbxGvL1NMS9Z6cpwvnuDJr7cbKMVJGlfdVYeb
	0S88CfiqEFu4BrD//F1h2uL2nmbc=
X-Google-Smtp-Source: AGHT+IER1rxGxK5ctzxTMJBt3yS7pUrVXF7R5aWFe0ooToJ57OdreQ91aBaLlNXkM2WjroJdQC5gwVwrlNhR2CJZ9/k=
X-Received: by 2002:a05:6e02:5a4:b0:39f:520e:7279 with SMTP id
 e9e14a558f8ab-39f520e72b3mr54926055ab.3.1725384732147; Tue, 03 Sep 2024
 10:32:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725334260.git.jpoimboe@kernel.org>
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Tue, 3 Sep 2024 10:32:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
Message-ID: <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Josh,

Thanks for the patchset! We really need this work so that we can undo our
hack for LTO enabled kernels.

On Mon, Sep 2, 2024 at 9:00=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Hi,
>
> Here's a new way to build livepatch modules called klp-build.
>
> I started working on it when I realized that objtool already does 99% of
> the work needed for detecting function changes.
>
> This is similar in concept to kpatch-build, but the implementation is
> much cleaner.
>
> Personally I still have reservations about the "source-based" approach
> (klp-convert and friends), including the fragility and performance
> concerns of -flive-patching.  I would submit that klp-build might be
> considered the "official" way to make livepatch modules.
>
> Please try it out and let me know what you think.  Based on v6.10.
>
> Also avaiable at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-bu=
ild-rfc

I tried to compile the code in this branch with gcc-12 and llvm-18. Some
of these errors are easy to fix (attached below). But some are trickier, fo=
r
example:

with gcc-12:
  ...
  BTFIDS  vmlinux
  NM      System.map
  SORTTAB vmlinux
incomplete ORC unwind tables in file: vmlinux
Failed to sort kernel tables

with clang-18:

<instantiation>:4:1: error: symbol '__alt_0' is already defined
    4 | __alt_0:
      | ^
<instantiation>:4:1: error: symbol '__alt_1' is already defined
    4 | __alt_1:
      | ^

Thanks,
Song

Fix/hack I have on top of this branch:

diff --git i/tools/objtool/check.c w/tools/objtool/check.c
index f55dec2932de..5c4152d60780 100644
--- i/tools/objtool/check.c
+++ w/tools/objtool/check.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
  */
-
+#define _GNU_SOURCE
 #include <string.h>
 #include <stdlib.h>
 #include <inttypes.h>
@@ -1519,7 +1519,7 @@ static void add_jump_destinations(struct
objtool_file *file)
        struct reloc *reloc;

        for_each_insn(file, insn) {
-               struct instruction *dest_insn;
+               struct instruction *dest_insn =3D NULL;
                struct section *dest_sec =3D NULL;
                struct symbol *dest_sym =3D NULL;
                unsigned long dest_off;
diff --git i/tools/objtool/elf.c w/tools/objtool/elf.c
index 7960921996bd..462ce897ff29 100644
--- i/tools/objtool/elf.c
+++ w/tools/objtool/elf.c
@@ -468,10 +468,8 @@ static void elf_add_symbol(struct elf *elf,
struct symbol *sym)
         *
         * TODO: is this still true?
         */
-#if 0
-       if (sym->type =3D=3D STT_NOTYPE && !sym->len)
+       if (sym->type =3D=3D STT_NOTYPE && !sym->len && false)
                __sym_remove(sym, &sym->sec->symbol_tree);
-#endif

        sym->demangled_name =3D demangle_name(sym);
 }
diff --git i/tools/objtool/klp-diff.c w/tools/objtool/klp-diff.c
index 76296e38f9ff..4a3f4172f4a5 100644
--- i/tools/objtool/klp-diff.c
+++ w/tools/objtool/klp-diff.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
  */
+#define _GNU_SOURCE
 #include <libgen.h>
 #include <stdio.h>
 #include <objtool/objtool.h>
@@ -1109,4 +1110,3 @@ int cmd_klp_diff(int argc, const char **argv)
        elf_write(elf_out);
        return 0;
 }
-


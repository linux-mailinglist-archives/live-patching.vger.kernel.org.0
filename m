Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96614A03AD
	for <lists+live-patching@lfdr.de>; Fri, 28 Jan 2022 23:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351684AbiA1WbY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 28 Jan 2022 17:31:24 -0500
Received: from vulcan.natalenko.name ([104.207.131.136]:36802 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351661AbiA1WbY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 28 Jan 2022 17:31:24 -0500
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2022 17:31:23 EST
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id CBFDCD8EDA2;
        Fri, 28 Jan 2022 23:22:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1643408565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ZsMDVPuYl19FEVoDJlylkVS5qA2hFCfWfEg2tA3jXk=;
        b=eBm+Hqvia66fBvajsmZc3l+b6Taj16wCjn6b4pS/4aRE4hu1jhtBFPca8qpwAOoOwoyL8d
        2TCWDAtTNYWlxztbLtkI2wTRPDoD8QKbfoo1IllkWMMNCqo/Iqg60sPGPz3p3ulMq42Hpk
        VtydXKoVS1ctRKvf1AlRmG7N5NkLzyU=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     mcgrof@kernel.org, Aaron Tomlin <atomlin@redhat.com>
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com
Subject: Re: [RFC PATCH v3 00/13] module: core code clean up
Date:   Fri, 28 Jan 2022 23:22:43 +0100
Message-ID: <11912240.O9o76ZdvQC@natalenko.name>
In-Reply-To: <20220128203934.600247-1-atomlin@redhat.com>
References: <20220128203934.600247-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello.

On p=E1tek 28. ledna 2022 21:39:21 CET Aaron Tomlin wrote:
> Hi Luis,
>=20
> [Note: Cc'd live-patching for feedback on livepatch specific changes]
>=20
> Firstly, apologies for the delay.
>=20
> As per your suggestion [1], this is an attempt to refactor and split
> optional code out of core module support code into separate components.
> This version is based on branch mcgrof/modules-next since a97ac8cb24a3/or
> modules-5.17-rc1. Please let me know your thoughts.
>=20
> Changes since v1 [2]:
>=20
>   - Moved module version support code into a new file
>=20
> Changes since v2 [3]:
>=20
>  - Move module decompress support to a separate file
>  - Make check_modinfo_livepatch() generic (Petr Mladek)
>  - Remove filename from each newly created file (Luis Chamberlain)
>  - Addressed some (i.e. --ignore=3DASSIGN_IN_IF,AVOID_BUG was used)
>    minor scripts/checkpatch.pl concerns e.g., use strscpy over
>    strlcpy and missing a blank line after declarations (Allen)

Thanks for your submission.

Aaron, could you please also include stats from `./scripts/bloat-o-meter` t=
o compare `vmlinux` sections size before and after your modifications?

> [1]: https://lore.kernel.org/lkml/YbEZ4HgSYQEPuRmS@bombadil.infradead.org/
> [2]: https://lore.kernel.org/lkml/20211228213041.1356334-1-atomlin@redhat=
=2Ecom/
> [3]: https://lore.kernel.org/lkml/20220106234319.2067842-1-atomlin@redhat=
=2Ecom/
>=20
>=20
> Aaron Tomlin (13):
>   module: Move all into module/
>   module: Simple refactor in preparation for split
>   module: Move livepatch support to a separate file
>   module: Move latched RB-tree support to a separate file
>   module: Move arch strict rwx support to a separate file
>   module: Move strict rwx support to a separate file
>   module: Move extra signature support out of core code
>   module: Move kmemleak support to a separate file
>   module: Move kallsyms support into a separate file
>   module: Move procfs support into a separate file
>   module: Move sysfs support into a separate file
>   module: Move kdb_modules list out of core code
>   module: Move version support into a separate file
>=20
>  MAINTAINERS                                   |    2 +-
>  include/linux/module.h                        |   92 +-
>  kernel/Makefile                               |    5 +-
>  kernel/debug/kdb/kdb_main.c                   |    5 +
>  kernel/module-internal.h                      |   50 -
>  kernel/module/Makefile                        |   18 +
>  kernel/module/arch_strict_rwx.c               |   44 +
>  kernel/module/debug_kmemleak.c                |   30 +
>  .../decompress.c}                             |    2 +-
>  kernel/module/internal.h                      |  202 ++
>  kernel/module/kallsyms.c                      |  502 +++++
>  kernel/module/livepatch.c                     |   74 +
>  kernel/{module.c =3D> module/main.c}            | 1879 +----------------
>  kernel/module/procfs.c                        |  142 ++
>  .../signature.c}                              |    0
>  kernel/module/signing.c                       |  120 ++
>  kernel/module/strict_rwx.c                    |   83 +
>  kernel/module/sysfs.c                         |  425 ++++
>  kernel/module/tree_lookup.c                   |  108 +
>  kernel/module/version.c                       |  110 +
>  kernel/module_signing.c                       |   45 -
>  21 files changed, 2032 insertions(+), 1906 deletions(-)
>  delete mode 100644 kernel/module-internal.h
>  create mode 100644 kernel/module/Makefile
>  create mode 100644 kernel/module/arch_strict_rwx.c
>  create mode 100644 kernel/module/debug_kmemleak.c
>  rename kernel/{module_decompress.c =3D> module/decompress.c} (99%)
>  create mode 100644 kernel/module/internal.h
>  create mode 100644 kernel/module/kallsyms.c
>  create mode 100644 kernel/module/livepatch.c
>  rename kernel/{module.c =3D> module/main.c} (63%)
>  create mode 100644 kernel/module/procfs.c
>  rename kernel/{module_signature.c =3D> module/signature.c} (100%)
>  create mode 100644 kernel/module/signing.c
>  create mode 100644 kernel/module/strict_rwx.c
>  create mode 100644 kernel/module/sysfs.c
>  create mode 100644 kernel/module/tree_lookup.c
>  create mode 100644 kernel/module/version.c
>  delete mode 100644 kernel/module_signing.c
>=20
>=20
> base-commit: a97ac8cb24a3c3ad74794adb83717ef1605d1b47
>=20


=2D-=20
Oleksandr Natalenko (post-factum)



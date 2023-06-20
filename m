Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3129973663A
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 10:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjFTIcM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 04:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjFTIcL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 04:32:11 -0400
Received: from xry111.site (xry111.site [89.208.246.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A142DB;
        Tue, 20 Jun 2023 01:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1687249929;
        bh=A8w7AsuE4m7ed5pms5PfeFktUKlrYqvzXBV6NU8G320=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AZ/WQ0eoGWtX+0Oh01Td6slakeaiMPQ3kXo/KLYl9BwSRyPrB60CfNfMzkDG1B7oo
         pJBhDL3bXMH+tmhYZDQqoAXMV9jbQDzD8YB89S4oLJucwGRnrxFoxUHB+eJtIUogKU
         x+sDSOWwg4uKXmWHFiq5sp45ZQNmS3N/M8h0uie8=
Received: from [192.168.124.11] (unknown [113.140.11.4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id 065366642B;
        Tue, 20 Jun 2023 04:32:06 -0400 (EDT)
Message-ID: <3f611195a5b3d1bf97e650fb441e21e434d8d889.camel@xry111.site>
Subject: Re: [RFC PATCH v1 00/23] LoongArch: Add objtool and ORC unwinder
 support
From:   Xi Ruoyao <xry111@xry111.site>
To:     Youling Tang <tangyouling@loongson.cn>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com, chenzhongjin@huawei.com,
        WANG Xuerui <kernel@xen0n.name>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Date:   Tue, 20 Jun 2023 16:32:04 +0800
In-Reply-To: <62d25870-2caa-18ab-e58c-cee0bc383e16@loongson.cn>
References: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
         <bed4d386c16701d14a2ea395edeb0368cb3d04ad.camel@xry111.site>
         <62d25870-2caa-18ab-e58c-cee0bc383e16@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.3 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 2023-06-20 at 16:29 +0800, Youling Tang wrote:
> Hi, Ruoyao
>=20
> On 06/20/2023 04:15 PM, Xi Ruoyao wrote:
> > It looks like only 19 patches are successfully delivered, out of 23.
> I'm sorry, somehow the patchset didn't reach the mailing list. Probably
> due to the sending limit being reached.

They've reached now.  Thanks!

> > And AFAIK objtool needs libelf from elfutils, and the LoongArch support
> > in elfutils is not complete (there are about ten failures in the test
> > suite as at the latest 0.189 release).=C2=A0 Do we need to add more Loo=
ngArch
> > support into libelf and/or declare a minimal needed libelf version for
> > LoongArch objtool?

> After the following series of patches [1], the elfutils test results
> are passed.
>=20
> [1]: https://sourceware.org/pipermail/elfutils-devel/2023q2/006107.html

Wow thanks, I'll add them into my build.  But I'm not sure if we need a
libelf version check or something in the kernel building system.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

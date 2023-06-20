Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A845F73669D
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 10:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjFTIsh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 04:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjFTIsg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 04:48:36 -0400
Received: from xry111.site (xry111.site [89.208.246.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939E010D2;
        Tue, 20 Jun 2023 01:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1687250911;
        bh=j08dQb+O2iKFopdM7Z31ujfjHNue2+MRh6l2jX/j0DE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MnTIGsbs1c+Sb2mJJtpaIPmXXxzQsg43tBoi9NiWGAsjDJ1s0w6PcME7a5ingAXXm
         oBak6wIUiWjEKuTAFs0JoL4iQ+FBozR3yvu3/yHv++Ds2uzewFMovZYeIofuc5ruzX
         HT+HvHwcd2sTKBE1182ITMhL4Db8o5bgkPt9Aseo=
Received: from localhost.localdomain (xry111.site [IPv6:2001:470:683e::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id EDCA16642D;
        Tue, 20 Jun 2023 04:48:28 -0400 (EDT)
Message-ID: <3b4e2e34b1c10e759691adc8a7d6ebed86949aa9.camel@xry111.site>
Subject: Re: [RFC PATCH v1 00/23] LoongArch: Add objtool and ORC unwinder
 support
From:   Xi Ruoyao <xry111@xry111.site>
To:     Peter Zijlstra <peterz@infradead.org>,
        Youling Tang <tangyouling@loongson.cn>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com, chenzhongjin@huawei.com,
        WANG Xuerui <kernel@xen0n.name>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Date:   Tue, 20 Jun 2023 16:48:27 +0800
In-Reply-To: <20230620083818.GW4253@hirez.programming.kicks-ass.net>
References: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
         <bed4d386c16701d14a2ea395edeb0368cb3d04ad.camel@xry111.site>
         <62d25870-2caa-18ab-e58c-cee0bc383e16@loongson.cn>
         <20230620083818.GW4253@hirez.programming.kicks-ass.net>
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

On Tue, 2023-06-20 at 10:38 +0200, Peter Zijlstra wrote:
> On Tue, Jun 20, 2023 at 04:29:12PM +0800, Youling Tang wrote:
> > Hi, Ruoyao
> >=20
> > On 06/20/2023 04:15 PM, Xi Ruoyao wrote:
> > > It looks like only 19 patches are successfully delivered, out of 23.
> > I'm sorry, somehow the patchset didn't reach the mailing list. Probably
> > due to the sending limit being reached.
>=20
> I got all the patches, but their threading is broken, they come in
> chunks of 5 or :/

Youling: when you need to resend a part of the series next time, you can
use the "--in-reply-to=3D" option of git send-email to avoid such an
issue.  See the man page of git send-email for details :).

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

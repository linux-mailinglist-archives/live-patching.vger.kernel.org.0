Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D994C3BDC
	for <lists+live-patching@lfdr.de>; Fri, 25 Feb 2022 03:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiBYCnf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 24 Feb 2022 21:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiBYCnf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 24 Feb 2022 21:43:35 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D85B1A6FB9;
        Thu, 24 Feb 2022 18:43:02 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K4Ywd1cHDz4xZq;
        Fri, 25 Feb 2022 13:42:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1645756978;
        bh=uy/+QxmmrhMRi+F2ioRtaNXPlP5t3+IxpHUFAACQloo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=YQRyLj7oyDLvap2U8mAluCdHr657d10dlyGR+HL1+sdgSRLj4sUDSEhuwzwyz+sC2
         cffFVCyT8f7bewB6UnbBVkvCkoZIiUiXnE5mg/0PJiTz6BKj0ox29Kf4sjsrJefvB6
         9gM5KtQRlbVioiucM3xjQ+A6dwTcyMNRjIqkq3PfAawxtJMASuODmewXD2LWLJ7j2d
         H1UwTXxq+81TB7lyOm8iLe8zre2oveH2Bki5dzNM1LPdtanXfO4VjjRuVdvOnDaOqO
         fVEC2A7nrPXbRxwx0YQYThN/6WBrMn4s2JC8e67OqBQYAXv6hxuVyQOopjYL393ZlU
         rx7zjexbhcynA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: [PATCH v2 02/13] tracing: Fix selftest config check for
 function graph start up test
In-Reply-To: <20220224095316.67729e2b@gandalf.local.home>
References: <cover.1640017960.git.christophe.leroy@csgroup.eu>
 <bdc7e594e13b0891c1d61bc8d56c94b1890eaed7.1640017960.git.christophe.leroy@csgroup.eu>
 <74775d33-2e54-96ab-4546-57eb2c9e50e0@csgroup.eu>
 <20220224095316.67729e2b@gandalf.local.home>
Date:   Fri, 25 Feb 2022 13:42:54 +1100
Message-ID: <87wnhjoedt.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> On Thu, 24 Feb 2022 13:43:02 +0000
> Christophe Leroy <christophe.leroy@csgroup.eu> wrote:
>
>> Hi Michael,
>>=20
>> Le 20/12/2021 =C3=A0 17:38, Christophe Leroy a =C3=A9crit=C2=A0:
>> > CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS is required to test
>> > direct tramp.
>> >=20
>> > Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>=20=20
>>=20
>> You didn't apply this patch when you merged the series. Without it I get=
=20
>> the following :
>
> Maybe they wanted my acked-by.

Yeah, I didn't want to take it via my tree without an ack. I meant to
reply to the patch saying that but ...

> But I'm working on a series to send to Linus. I can pick this patch up, as
> it touches just my code.

Thanks.

cheers

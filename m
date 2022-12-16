Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A80164EB03
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 12:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiLPL5K (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 06:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLPL5J (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 06:57:09 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A3B264F;
        Fri, 16 Dec 2022 03:57:08 -0800 (PST)
Received: from frontend03.mail.m-online.net (unknown [192.168.6.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4NYSJK5z16z1r15N;
        Fri, 16 Dec 2022 12:57:05 +0100 (CET)
Received: from localhost (dynscan3.mnet-online.de [192.168.6.84])
        by mail.m-online.net (Postfix) with ESMTP id 4NYSJK33KXz1qqlR;
        Fri, 16 Dec 2022 12:57:05 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan3.mail.m-online.net [192.168.6.84]) (amavisd-new, port 10024)
        with ESMTP id qdIf7S9_5Cgo; Fri, 16 Dec 2022 12:57:03 +0100 (CET)
X-Auth-Info: I9LqOxI019SRTRCJIUeMssxvg6YNOJZppYTy2eQwvJzS6pIPt2lkGXfejHqM6Sjd
Received: from igel.home (aftr-62-216-205-197.dynamic.mnet-online.de [62.216.205.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 16 Dec 2022 12:57:03 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id AA35E2C31C2; Fri, 16 Dec 2022 12:57:03 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
        <CAMuHMdWM6+pC3yUqy+hHRrAf1BCz2sz1KQv2zxS+Wz-639X-aA@mail.gmail.com>
        <ad09966d-9357-1c32-e491-a402af8dac6e@huawei.com>
        <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
        <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com>
        <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
        <49070ac3-02bb-a3b3-b929-ede07e3b2c95@huawei.com>
        <e81710a9-2c45-0724-ec5f-727977202858@huawei.com>
        <CAMuHMdWAAQNJd21fhodDONb40LFMae3V_517iT22FykCqG90Og@mail.gmail.com>
        <4aaede14-8bd3-6071-f17b-7efcb5f0de42@huawei.com>
        <66ec4021-b633-09ba-73ee-b24cdb3fa25a@huawei.com>
X-Yow:  Is there something I should be DOING with a GLAZED DONUT??
Date:   Fri, 16 Dec 2022 12:57:03 +0100
In-Reply-To: <66ec4021-b633-09ba-73ee-b24cdb3fa25a@huawei.com> (Leizhen's
        message of "Fri, 16 Dec 2022 17:36:30 +0800")
Message-ID: <87h6xvk1dc.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Dez 16 2022, Leizhen (ThunderTown) wrote:

> It seems that the problem is still strcmp(). After I commented strcmp() in
> arch/m68k/include/asm/string.h, and force it to use the one in lib/string.c,
> it works well.

Does that help?

diff --git a/arch/m68k/include/asm/string.h b/arch/m68k/include/asm/string.h
index f759d944c449..cdafd67774e0 100644
--- a/arch/m68k/include/asm/string.h
+++ b/arch/m68k/include/asm/string.h
@@ -42,18 +42,19 @@ static inline char *strncpy(char *dest, const char *src, size_t n)
 #define __HAVE_ARCH_STRCMP
 static inline int strcmp(const char *cs, const char *ct)
 {
-	char res;
+	int res = 0, tmp = 0;
 
 	asm ("\n"
 		"1:	move.b	(%0)+,%2\n"	/* get *cs */
-		"	cmp.b	(%1)+,%2\n"	/* compare a byte */
+		"	move.b	(%1)+,%3\n"	/* get *ct */
+		"	cmp.b	%3,%2\n"	/* compare a byte */
 		"	jne	2f\n"		/* not equal, break out */
 		"	tst.b	%2\n"		/* at end of cs? */
 		"	jne	1b\n"		/* no, keep going */
 		"	jra	3f\n"		/* strings are equal */
-		"2:	sub.b	-(%1),%2\n"	/* *cs - *ct */
+		"2:	sub.l	%3,%2\n"	/* *cs - *ct */
 		"3:"
-		: "+a" (cs), "+a" (ct), "=d" (res));
+		: "+a" (cs), "+a" (ct), "+d" (res), "+d" (tmp));
 	return res;
 }
 #endif /* CONFIG_COLDFIRE */

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."

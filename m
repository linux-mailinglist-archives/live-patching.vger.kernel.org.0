Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7268264EC1C
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 14:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiLPNbM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 08:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiLPNbK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 08:31:10 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11114EE0D;
        Fri, 16 Dec 2022 05:31:08 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NYVHp5R52zqTB8;
        Fri, 16 Dec 2022 21:26:46 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 16 Dec 2022 21:31:05 +0800
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
To:     Andreas Schwab <schwab@linux-m68k.org>
CC:     Geert Uytterhoeven <geert@linux-m68k.org>,
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
 <66ec4021-b633-09ba-73ee-b24cdb3fa25a@huawei.com> <87h6xvk1dc.fsf@igel.home>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <1739960e-7f95-88ef-9b91-31c7504bb7fd@huawei.com>
Date:   Fri, 16 Dec 2022 21:31:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87h6xvk1dc.fsf@igel.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/12/16 19:57, Andreas Schwab wrote:
> On Dez 16 2022, Leizhen (ThunderTown) wrote:
> 
>> It seems that the problem is still strcmp(). After I commented strcmp() in
>> arch/m68k/include/asm/string.h, and force it to use the one in lib/string.c,
>> it works well.
> 
> Does that help?

It still needs to add 'volatile' to prevent compiler optimizations.
Otherwise,
Tested-by: Zhen Lei <thunder.leizhen@huawei.com>

> 
> diff --git a/arch/m68k/include/asm/string.h b/arch/m68k/include/asm/string.h
> index f759d944c449..cdafd67774e0 100644
> --- a/arch/m68k/include/asm/string.h
> +++ b/arch/m68k/include/asm/string.h
> @@ -42,18 +42,19 @@ static inline char *strncpy(char *dest, const char *src, size_t n)
>  #define __HAVE_ARCH_STRCMP
>  static inline int strcmp(const char *cs, const char *ct)
>  {
> -	char res;
> +	int res = 0, tmp = 0;
>  
>  	asm ("\n"

-       asm ("\n"
+       asm volatile ("\n"


>  		"1:	move.b	(%0)+,%2\n"	/* get *cs */
> -		"	cmp.b	(%1)+,%2\n"	/* compare a byte */
> +		"	move.b	(%1)+,%3\n"	/* get *ct */
> +		"	cmp.b	%3,%2\n"	/* compare a byte */
>  		"	jne	2f\n"		/* not equal, break out */
>  		"	tst.b	%2\n"		/* at end of cs? */
>  		"	jne	1b\n"		/* no, keep going */
>  		"	jra	3f\n"		/* strings are equal */
> -		"2:	sub.b	-(%1),%2\n"	/* *cs - *ct */
> +		"2:	sub.l	%3,%2\n"	/* *cs - *ct */
>  		"3:"
> -		: "+a" (cs), "+a" (ct), "=d" (res));
> +		: "+a" (cs), "+a" (ct), "+d" (res), "+d" (tmp));
>  	return res;
>  }
>  #endif /* CONFIG_COLDFIRE */
> 

-- 
Regards,
  Zhen Lei

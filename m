Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2204616263
	for <lists+live-patching@lfdr.de>; Wed,  2 Nov 2022 13:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiKBMBT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Wed, 2 Nov 2022 08:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiKBMBB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Nov 2022 08:01:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06ED7220C4
        for <live-patching@vger.kernel.org>; Wed,  2 Nov 2022 05:00:56 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-258-1yQNw3MuPJOLWPGjyRulkQ-1; Wed, 02 Nov 2022 12:00:53 +0000
X-MC-Unique: 1yQNw3MuPJOLWPGjyRulkQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 2 Nov
 2022 12:00:51 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Wed, 2 Nov 2022 12:00:51 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Zhen Lei' <thunder.leizhen@huawei.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luis Chamberlain" <mcgrof@kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>
Subject: RE: [PATCH v8 4/9] kallsyms: Reduce the memory occupied by
 kallsyms_seqs_of_names[]
Thread-Topic: [PATCH v8 4/9] kallsyms: Reduce the memory occupied by
 kallsyms_seqs_of_names[]
Thread-Index: AQHY7pgsdRO9dUiW6k27i3NhSmpxX64riAdg
Date:   Wed, 2 Nov 2022 12:00:51 +0000
Message-ID: <bd30cbc9b7594261a7b9da26e9c98da4@AcuMS.aculab.com>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
 <20221102084921.1615-5-thunder.leizhen@huawei.com>
In-Reply-To: <20221102084921.1615-5-thunder.leizhen@huawei.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Zhen Lei
> Sent: 02 November 2022 08:49
> 
> kallsyms_seqs_of_names[] records the symbol index sorted by address, the
> maximum value in kallsyms_seqs_of_names[] is the number of symbols. And
> 2^24 = 16777216, which means that three bytes are enough to store the
> index. This can help us save (1 * kallsyms_num_syms) bytes of memory.

You can get the compiler to do the 'heavy lifting' for you.

struct uint24 {
    unsigned int val24:24;
} __attribute__((packed));

struct uint24 table[1024];

works fine.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


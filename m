Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3831C59C1C7
	for <lists+live-patching@lfdr.de>; Mon, 22 Aug 2022 16:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbiHVOmO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Aug 2022 10:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234896AbiHVOmN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Aug 2022 10:42:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C216F371B1;
        Mon, 22 Aug 2022 07:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661179332; x=1692715332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M+vT8QnLNMo6qMrgIuZIijfJ1dcMOL8NnZ+wIrdoKs8=;
  b=KOF1lzIXGyI5m8XUrvL3Bhl/HnkoFz3+84m6P1JgqBFP1p1pa2ZNSZRB
   76L2oLDuJ0rhqKD7twkIF+CBuZNb+TxBZ7o9/rcI/3VH+IN/M9Vxq8lLe
   fKneQfP62cu1CImAKguTKxtQ5sxCYm8cnDDDpTcGpzOPXT94zAjh8AUwm
   IybKoSrMS8dxNuolMlC0wf4VidXk3p1H7s/OiU/KVof12Dzu5ptF7jElX
   aelbQx2Sf6WrQMxvcTR9q+8BTdYKdlR1LeftsEfnWlAbQn314DMRW174O
   s8Ua15HSXMB3JyL+Xpo9fnUmsC2QrWNzsUiPMBeI3ziC9LWgzxdBmVXNl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="379721069"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="379721069"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 07:42:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="608981332"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 22 Aug 2022 07:42:06 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27MEg4HA003194;
        Mon, 22 Aug 2022 15:42:04 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        "Anil S Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
        lkp@intel.com,
        =?UTF-8?q?F=C4=81ng-ru=C3=AC=20S=C3=B2ng?= <maskray@google.com>,
        linux-hardening@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>,
        Marios Pomonis <pomonis@google.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        llvm@lists.linux.dev, Jessica Yu <jeyu@kernel.org>
Subject: Re: [RFC PATCH 0/3] kallsyms: add option to include relative filepaths into kallsyms
Date:   Mon, 22 Aug 2022 16:40:22 +0200
Message-Id: <20220822144022.7127-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Thu, 18 Aug 2022 13:53:03 +0200

> This is an early RFC to not rewrite stuff one more time later on if
> the implementation is not acceptable or any major design changes are
> required. For the TODO list, please scroll to the end.
> 
> Make kallsyms independent of symbols positions in vmlinux (or module)
> by including relative filepath in each symbol's kallsyms value. I.e.
> 
> dev_gro_receive -> net/core/gro.c:dev_gro_receive

Oops, forgot to Cc some more folks I was talking to regarding the
previous implementation <O> Fixed, pls let me know if you prefer to
get a resend.

> -- 
> 2.37.2

Thanks,
Olek

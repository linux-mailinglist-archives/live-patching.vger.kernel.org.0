Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2544AAC7D
	for <lists+live-patching@lfdr.de>; Sat,  5 Feb 2022 21:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381240AbiBEUdN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 5 Feb 2022 15:33:13 -0500
Received: from p3plsmtpa07-01.prod.phx3.secureserver.net ([173.201.192.230]:43310
        "EHLO p3plsmtpa07-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381239AbiBEUdN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 5 Feb 2022 15:33:13 -0500
Received: from localhost ([82.17.115.212])
        by :SMTPAUTH: with ESMTPA
        id GRk6nOlDx9DrwGRk8neHus; Sat, 05 Feb 2022 13:33:12 -0700
X-CMAE-Analysis: v=2.4 cv=RN52o6u+ c=1 sm=1 tr=0 ts=61fedf08
 a=9gipVNR6X1CoIeAWHwLoWw==:117 a=9gipVNR6X1CoIeAWHwLoWw==:17
 a=IkcTkHD0fZMA:10 a=qS7egxAB0wbPWyOtm4cA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: atomlin@atomlin.com
Date:   Sat, 5 Feb 2022 20:33:10 +0000
From:   Aaron Tomlin <atomlin@atomlin.com>
To:     Allen <allen.lkml@gmail.com>
Cc:     Aaron Tomlin <atomlin@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, jeyu@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        ghalat@redhat.com, void@manifault.com,
        Joe Perches <joe@perches.com>
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Message-ID: <20220205203310.ngedb64jlii7hmaw@ava.usersys.com>
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <CAOMdWS+PDCNO3mpGOU-521mWcMwQW0R4iacsWPkgGZL0aYbxrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOMdWS+PDCNO3mpGOU-521mWcMwQW0R4iacsWPkgGZL0aYbxrw@mail.gmail.com>
X-CMAE-Envelope: MS4xfMiT/mCToqixUUYdfqKYJ3gd4+YuAYoW86EpX7LAhgPi+Alh83PcANN7rHcWm8YYwy94twc+YV2YdbTacSs5Wh5c5oGhEd56/xGkrHdT78krMOlH01Ul
 HxfKtyUpwACMypTXJMYUnu6V1eiWoQaa6V7YMpuhTfBRjhXeiqLNz5k0bEjAtTnrFMCrpSbcvzFdWBVojxjszUDeaFxX0cDyhSeS5Tf/Mg5NEBztm1PzPYRL
 QEQ2g8gke70BCZTkwQDkfvnE9eTYzXS/ttG7ZM/yxT30Y1yJIW6lehfo4S9yV0ELO8DbuyDQ6iY/yDxHZL9NZrVLznY6ovgt20r8xm/bL5jPihJKCx/TDpld
 2H5/fkBHSMYb+VT3qqOgtp+KqVGlMhBcVAl1rH/mLFjWjVzBWMBmTiE1CJQ3LZ9OQFa5dXFui4GfBxnYbOHOXnLibbWRPPkpN/dAJVKgo3v954gVzx0PRTm8
 Fcz8//uy5unmkTstnHUOKeLIpyoCF9EpIXqArAiQp693BNzLgkyVmmBzenThf79uNZcTceLp7+eIsDZcNpfuMr+Qk+7QLqjFHnVrYRD9HBOj5yiOPP7Z2zll
 Ov4=
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-02-01 08:44 -0800, Allen wrote:
> Build/boot test on qemu. Running more tests on BM.

Thanks Allen.

Kind regards,

-- 
Aaron Tomlin

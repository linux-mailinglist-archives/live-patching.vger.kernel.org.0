Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4DEA138C7E
	for <lists+live-patching@lfdr.de>; Mon, 13 Jan 2020 08:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgAMHsO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Jan 2020 02:48:14 -0500
Received: from mail01.vodafone.es ([217.130.24.71]:42301 "EHLO
        mail01.vodafone.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgAMHsN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Jan 2020 02:48:13 -0500
IronPort-SDR: 8k5nAHk5tSrTpb4ux6cC4Xb5A/2PkQeBZDJ0pT4o3XJztqLTXMmSeRk4c0o36NkjeUt6spEZVS
 TtNZCVDX96GQ==
IronPort-PHdr: =?us-ascii?q?9a23=3AG0jPtRB3csWRSAixMPf/UyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSPX7pcbcNUDSrc9gkEXOFd2Cra4d0KyM7fGrADVcqb+681k6OKRWUB?=
 =?us-ascii?q?EEjchE1ycBO+WiTXPBEfjxciYhF95DXlI2t1uyMExSBdqsLwaK+i764jEdAA?=
 =?us-ascii?q?jwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba58IRmsswnct80bjYR/JqosxR?=
 =?us-ascii?q?bCv2dFdflRyW50P1yYggzy5t23/J5t8iRQv+wu+stdWqjkfKo2UKJVAi0+P2?=
 =?us-ascii?q?86+MPkux/DTRCS5nQHSWUZjgBIAwne4x7kWJr6rzb3ufB82CmeOs32UKw0VD?=
 =?us-ascii?q?G/5KplVBPklCEKPCM//G3Ql8J/kLhUoBehphBm3YPUZ5uVNOJ5fqPHZ9waWX?=
 =?us-ascii?q?ROUt9PWCxHG4+xc5cPD/YbMulEr4nyuV4OogW4BQmwHe/g1DlIimbx06091e?=
 =?us-ascii?q?QuDwHH0BU+ENIIrX/YqNv4OLsOXeywyqTD0DfNYO5M2Trl5obGcgohr++PU7?=
 =?us-ascii?q?xtfsXe1UYhGhjZjliStYPpIy+Z2vgTv2Wd8uFuVfivi2kiqwxpuDag2NsshZ?=
 =?us-ascii?q?fThokIyl/E8iN5wIkoLtC/UE50f8KkH4VKtyCUMIt2RMwiTnpouCYh0bIJpY?=
 =?us-ascii?q?S3czQNyJQi3RLfa/+HfpGO7xn+V+iROS91iGx4dL+9nRq+7EatxvHmWsWq31?=
 =?us-ascii?q?tGtCRIn9nKu3sQzRLc8NKHReF4/kq53DaP0B3c5f9cLEAvkKrbN4Yhwrktlp?=
 =?us-ascii?q?oPqUjDHjH5mEHxjKKOc0Ur4Omo6+D9Yrr4op+QK4B5hhvgMqQph8OwG+o4Mg?=
 =?us-ascii?q?8IX2eF4+izyqbj8VX4QLVMkPI2jrHUvI7HKckZvKK1HgFY3po55xqhADqqyt?=
 =?us-ascii?q?oVkHkfIFJAYh2HjozpO1/UIPD/CPeym0ysnyl3x//YJL3gDJLNLn7MkLr6fb?=
 =?us-ascii?q?Z98FVTxxYpwd9D4JJUD6sNIPLwWkPprtzXEgc5MxCow+bgENh90oIeWXyRDa?=
 =?us-ascii?q?OAKKPdq0OI6f4vI+mNYo8Vty3wK+Yq5/Hwl381g1wdcrez3ZsRdn+4Gu5qI0?=
 =?us-ascii?q?KDYXrj0Z89FjIOvxQzCfTjlFaCUDhcT2i9Urh65TwhDo+iS4DZSdOXjaSFzR?=
 =?us-ascii?q?u8S6Vbem1cQm+LF3igI52JR/oWdyWULc9ikicOXpCuToYg0VelswqsmJR9Ke?=
 =?us-ascii?q?+BwiAEuIir699z6KWHjRwu+CZrCMKS+2GWRWoylWQNAT81ivMs6Xdhw0uOhP?=
 =?us-ascii?q?Ery8dTEsZesqgRCgo=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EGEgBqIBxeeiMYgtkUBjMYGgEBAQE?=
 =?us-ascii?q?BAQEBAQMBAQEBEQEBAQICAQEBAYF7AgEBFwEBgS6BTVIgEpNQgU0fg0OLY4E?=
 =?us-ascii?q?Agx4VhggTDIFbDQEBAQEBGxoCAQGEQE4BF4ESJDoEDQIDDQEBBQEBAQEBBQQ?=
 =?us-ascii?q?BAQIQAQEJDQsEK4VKgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVOFTwE?=
 =?us-ascii?q?BM4UolzUBhASJAA0NAoUdgkUECoEJgRojgTYBjBgagUE/gSMhgisIAYIBgn8?=
 =?us-ascii?q?BEgFsgkiCWQSNQhIhgQeIKZgXgkEEdolMjAKCNwEPiAGEMQMQgkUPgQmIA4R?=
 =?us-ascii?q?OgX2jN1eBDA16cTMagiYagSBPGA2WSECBFhACT4kugjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2EGEgBqIBxeeiMYgtkUBjMYGgEBAQEBAQEBAQMBAQEBE?=
 =?us-ascii?q?QEBAQICAQEBAYF7AgEBFwEBgS6BTVIgEpNQgU0fg0OLY4EAgx4VhggTDIFbD?=
 =?us-ascii?q?QEBAQEBGxoCAQGEQE4BF4ESJDoEDQIDDQEBBQEBAQEBBQQBAQIQAQEJDQsEK?=
 =?us-ascii?q?4VKgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVOFTwEBM4UolzUBhASJA?=
 =?us-ascii?q?A0NAoUdgkUECoEJgRojgTYBjBgagUE/gSMhgisIAYIBgn8BEgFsgkiCWQSNQ?=
 =?us-ascii?q?hIhgQeIKZgXgkEEdolMjAKCNwEPiAGEMQMQgkUPgQmIA4ROgX2jN1eBDA16c?=
 =?us-ascii?q?TMagiYagSBPGA2WSECBFhACT4kugjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.69,428,1571695200"; 
   d="scan'208";a="304668533"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail01.vodafone.es with ESMTP; 13 Jan 2020 08:48:10 +0100
Received: (qmail 10454 invoked from network); 12 Jan 2020 05:37:46 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <live-patching@vger.kernel.org>; 12 Jan 2020 05:37:46 -0000
Date:   Sun, 12 Jan 2020 06:37:45 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     live-patching@vger.kernel.org
Message-ID: <19632617.579275.1578807466069.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

